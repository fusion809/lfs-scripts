# Monitoring function for a loop of builds (e.g. from cleanup)
function cleanup_build_times {
    echo "Monitoring scheduled autobuilds (Press Ctrl+C to stop)..."
    local monitored_pids=""
    
    while true; do
        # Find all current autobuild lines
        local current_lines=$(ps -eo pid,args | grep "autobuild.sh" | grep -v grep)
        
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            
            local pid=$(echo "$line" | awk '{print $1}')
            local pkg=$(echo "$line" | grep -oP '(?<=autobuild\.sh\s)\S+')
            
            # If we haven't monitored this PID yet
            if [[ ! " $monitored_pids " =~ " $pid " ]]; then
                echo "------------------------------------------------"
                echo "Monitoring build of: $pkg (PID $pid)..."
                
                # Start tracking the time live
                pelaps_live "$pid"
                
                # Record it as monitored
                monitored_pids="$monitored_pids $pid"
            fi
        done <<< "$current_lines"
        
        sleep 5
    done
}

# Monitoring function for a loop of builds (e.g. from cleanup)
# Enhanced Monitoring function with summary on exit
# Fixed Monitoring function using actual process start time for summary
# Fixed Monitoring function using actual process start time for summary
function cleanup_build_times {
    echo "[LFS-MONITOR] Initializing tracking loop for autobuilds..."
    echo "[LFS-MONITOR] Using actual process start times for all duration calculations."

    local monitored_pids=""
    local -a summary_list
    local idle_count=0
    local max_idle=20

    trap '
        echo -e "\n\n================================================"
        echo "           BUILD DURATION SUMMARY"
        echo "================================================"
        if [ ${#summary_list[@]} -eq 0 ]; then
            echo "No builds were completed during this session."
        else
            for entry in "${summary_list[@]}"; do
                echo "$entry"
            done
        fi
        echo "================================================"
        trap - INT
        return
    ' INT

    while true; do
        local current_lines=$(ps -eo pid,args | grep "autobuild.sh" | grep -v grep)

        if [[ -z "$current_lines" ]]; then
            ((idle_count++))
            if [[ $idle_count -ge $max_idle && -n "$monitored_pids" ]]; then
                echo -e "\n[LFS-MONITOR] No further builds detected. Finishing tracking."
                kill -s INT $$
                return
            fi
        else
            idle_count=0
            while IFS= read -r line; do
                [[ -z "$line" ]] && continue

                local pid=$(echo "$line" | awk '{print $1}')
                local pkg=$(echo "$line" | grep -oP '(?<=autobuild\.sh\s)\S+')

                if [[ ! " $monitored_pids " =~ " $pid " ]]; then
                    # 1. Get actual start time of this process
                    local start_str=$(pstart "$pid")
                    if [[ -z "$start_str" ]]; then
                         # Process might have just ended
                         continue
                    fi
                    local t_start=$(date -d "$start_str" +"%s")

                    echo "------------------------------------------------"
                    echo "Monitoring build of: $pkg (Started: $start_str)"

                    # 2. Run the live display
                    pelaps_live "$pid"

                    # 3. Use end time for duration string based on original start
                    local t_end=$(date +"%s")
                    local elapsed=$((t_end - t_start))
                    local duration_str=$(printf '%02d:%02d:%02d' $(($elapsed/3600)) $((($elapsed%3600)/60)) $(($elapsed%60)))

                    summary_list+=("Package: $(printf '%-20s' "$pkg") | Duration: $duration_str")
                    monitored_pids="$monitored_pids $pid"
                fi
            done <<< "$current_lines"
        fi

        sleep 3
    done
}


v1_cleanup_old_libraries_gpt() {
    local dep_cache="/tmp/lfs_dep_cache.txt"
    local pkg_cache="/tmp/lfs_pkg_cache.txt"

    echo "[LFS-AUTOBUILD] Generating comprehensive dependency and package caches..."

    # 1. Generate system-wide dependency cache (File -> Shared Lib SONAMEs)
    find /usr/bin /usr/lib /lib /opt -type f \( -executable -o -name "*.so*" \) 2>/dev/null |
    xargs -P$(nproc) -I{} sh -c "readelf -d '{}' 2>/dev/null | grep -q '(NEEDED)' && printf '%s: ' '{}' && readelf -d '{}' 2>/dev/null | grep '(NEEDED)' | sed -E 's/.*\[(.*)\].*/\1/' | tr '\n' ' ' && echo" > "$dep_cache"

    # 2. Generate package inventory mapping (File -> Package)
    grep -r "^/" /var/lib/book-packages /var/lib/custom-packages 2>/dev/null | sed -E 's|/var/lib/[^/]+-packages/([^:]+):(.*)|\2:\1|' > "$pkg_cache"

    echo "[LFS-AUTOBUILD] Caches generated. Scanning libraries..."

    # 3. Identify old versions (everything but the latest for each base)
    local old_libs=($(find /usr/lib /lib -type f -name "lib*.so.[0-9]*" ! -name "*.dbg" ! -name "*-gdb.py" 2>/dev/null \
    | sort -V \
    | awk '
    {
        base=$0
        sub(/\.so\.[0-9.]+$/, ".so", base)
        if (prev_base && base != prev_base) {
            for (i=1; i < prev_count; i++) print prev[i]
            prev_count = 0
        }
        prev[++prev_count] = $0
        prev_base = base
    }
    END {
        for (i=1; i < prev_count; i++) print prev[i]
    }'))

    if [ ${#old_libs[@]} -eq 0 ]; then
        echo "No old library versions detected."
        return
    fi

    for i in "${old_libs[@]}"; do
        [ -f "$i" ] || continue
        echo "------------------------------------------------"
        echo "Evaluating: $i"

        # Check for symbolic link target protection
        if [ -n "$(find /usr/lib /lib -maxdepth 1 -type l -ls 2>/dev/null | grep -w "$(basename "$i")")" ]; then
            echo "Result: Skipping (targeted by a symlink)."
            continue
        fi

        # 4. GET SONAME OF THE LIBRARY
        local soname=$(readelf -d "$i" 2>/dev/null | grep SONAME | sed -E 's/.*\[(.*)\].*/\1/')
        [ -z "$soname" ] && soname=$(basename "$i")
        echo "SONAME: $soname"

        # [NEW] Check if the SONAME is already pointed to a NEWER library version
        # If we are deleting libfoo.so.8.0.8, but libfoo.so.8 points to 8.0.9, then 8.0.8 is redundant.
        local current_active=$(readlink -f "/usr/lib/$soname" 2>/dev/null || readlink -f "/lib/$soname" 2>/dev/null)
        if [ -n "$current_active" ] && [ "$(realpath -m "$current_active")" != "$(realpath -m "$i")" ]; then
            # Double check: does the current active one actually provide the SONAME?
            if readelf -d "$current_active" 2>/dev/null | grep SONAME | grep -q "\[$soname\]"; then
                echo "Result: Redundant (same SONAME provided by $(basename "$current_active")). Deleting $i..."
                sudo rm -f -- "$i"
                continue
            fi
        fi

        # 5. Dependency check using SONAME
        local deps=($(grep -F " $soname " "$dep_cache" | cut -d: -f1))

        if [ ${#deps[@]} -eq 0 ]; then
            echo "Result: Unused. Deleting $i..."
            sudo rm -f -- "$i"
            continue
        fi

        echo "Status: Library ($soname) has ${#deps[@]} remaining dependents."

        # 6. Comprehensive package identification
        local found_pkgs=()
        for d in "${deps[@]}"; do
            local p=$(grep "^$d:" "$pkg_cache" | cut -d: -f2)
            if [ -n "$p" ]; then
                 found_pkgs+=("$p")
            else
                 echo "Warning: Dependent binary $d is NOT recorded in any package inventory."
                 echo "Result: Blocking deletion of $i for safety."
                 continue 2
            fi
        done

        local pkgs=($(printf "%s\n" "${found_pkgs[@]}" | sort -u))

        # [NEW] Optimization: If the SONAME is still present in the system linked to a file and we aren't deleting it,
        # then we don't need to rebuild any packages that link to this SONAME.
        # This prevents accidental rebuild loops when minor version bumps occur.
        local provider_exists=false
        # We already checked current_active above, but let's be thorough
        if [ -n "$current_active" ] && [ -f "$current_active" ]; then
             provider_exists=true
        fi

        if [ "$provider_exists" = "true" ]; then
             echo "Result: Dependents exist but $(basename "$current_active") already handles SONAME $soname. Deleting $i..."
             sudo rm -f -- "$i"
             continue
        fi

        echo "Packages requiring rebuild: ${pkgs[@]}"

        # 7. Rebuild loop
        local rebuild_success=true
        for pkg in "${pkgs[@]}"; do
            echo "Action: Rebuilding $pkg (upstream) to transition off $soname..."
            if ! autobuild --upstream --force "$pkg"; then
                echo "Error: Failed to rebuild $pkg. Aborting cleanup for $i."
                rebuild_success=false
                break
            fi
        done

        if [ "$rebuild_success" = true ]; then
             echo "Verification: Re-checking dependencies for $soname..."
             local remaining=0
             for d in "${deps[@]}"; do
                  if [ -f "$d" ] && readelf -d "$d" 2>/dev/null | grep -q "\[$soname\]"; then
                       # Check if it still links to the OLD library specifically? No, readelf only shows SONAME.
                       # But if we successfully rebuilt, it might now link to a NEW SONAME.
                       echo "Persistence: $d still linked to $soname."
                       remaining=1
                       break
                  fi
             done

             if [ $remaining -eq 0 ]; then
                 echo "Final Action: All known dependents cleared. Deleting $i."
                 sudo rm -f -- "$i"
             else
                 echo "Final Action: Keeping $i (unmatched dependencies remain)."
             fi
        else
            echo "Final Action: Keeping $i (rebuilds failed)."
        fi
    done

    rm -f "$dep_cache" "$pkg_cache"
}

