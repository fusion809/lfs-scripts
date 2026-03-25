# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH


# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="hnixos"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-history-substring-search zsh-syntax-highlighting zsh-autosuggestions vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_AU.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
function szsh {
	source $HOME/.zshrc
}

function vzsh {
	vim $HOME/.zshrc
}

export LFS="$HOME/lfs-scripts"

function cdlfs {
	cd $LFS/$1
}
function ugrub {
	sudo grub-mkconfig -o /boot/grub/grub.cfg
}

ver=$(wget -cqO- https://www.linuxfromscratch.org/lfs/view/systemd/index.html | grep -i "version" | sed 's/^\s*//g' | cut -d ' ' -f 2 | sed 's/-systemd//g')

if [[ $ver != $(cat /etc/os-release | grep VERSION_ID | cut -d '"' -f 2) ]]; then
	printf "New update to LFS manual is out."
fi
export SRC="/sources"
export ARC="$SRC/archives"

function srcs {
	sudo du -h --max-depth=0 $SRC/* | sort -h
}

function cds {
	cd $SRC/$1
}

function cda {
	cd $ARC/$1
}

function os-release {
	cat /etc/os-release | grep "PRETTY_NAME" | cut -d '"' -f 2
}

function upos {
	upver=$(wget -cqO- https://www.linuxfromscratch.org/lfs/view/systemd/index.html | grep "Version" | sed 's/^\s*//g' | cut -d ' ' -f 2 | sed 's/-systemd//g')
	sudo sed -i -E "s|r[0-9]{2,}\.[0-9]-[0-9]+|$upver|g" /etc/os-release /etc/lfs-release /etc/lsb-release
}
alias os_info=os-release
alias os-info=os-release

function download {
	unset DOWNLOAD_x86_64
	source *.info
	if [[ -n $DOWNLOAD_x86_64 ]]; then
		echo "x86_64!"
		URL=$(cat *.info | grep DOWNLOAD_x86_64 | cut -d '"' -f 2)
	else
		echo "Not x86_64!"
		URL=$(cat *.info | grep DOWNLOAD | cut -d '"' -f 2)
	fi
	echo "URL=$URL"
	wget -c $URL
}

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=/usr"
export ZSH_HIGHLIGHT_STYLES[comment]="fg=cyan,dimmed"
export PATH=$PATH:/opt/rustc/bin:/opt/jdk/bin:/opt/qt6/bin:/opt/texlive/2025/bin/x86_64-linux:/sbin:/usr/sbin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/rustc/lib:/opt/jdk/lib:/opt/qt6/lib:/opt/texlive/2025/lib
export timestamp=$(uptime -s)
if ! [[ -d $HOME/plots ]]; then
	mkdir $HOME/plots
fi
function plot {
	systemd-analyze plot > $HOME/plots/$timestamp.svg
}

if ! [[ -f $HOME/plots/$timestamp.svg ]]; then
	plot
fi

function vsb {
	vim *.SlackBuild
}

function cdp {
	cd ~/plots/$1
}

function cdps {
	cd ~/Screenshots/$1
}

function shplot {
	if [[ -n $1 ]] && [[ $1 != "1" ]]; then
		file=$HOME/plots/"$(ls $HOME/plots | grep -v "$timestamp" | tail -n "$1" | head -n 1)"
	else
		file="$HOME/plots/$timestamp.svg"
	fi
	eog "$file"
}

alias show_plot=shplot

function boot_times {
	cat ~/plots/*.svg \
| grep kernel \
| grep user \
| sed 's/.*= //g' \
| sort -n
}

alias bts=boot_times

function boot_time {
	if [[ -f ~/plots/$timestamp.svg ]]; then
		filename=$HOME/plots/$timestamp.svg
	else
		filename=$HOME/plots/outliers/$timestamp.svg
	fi
	cat $filename \
| grep kernel \
| grep user \
| sed 's/.*= //g'
}

alias bt=boot_time

function avg_boot_time {
	boot_times | awk '{sum+=$1; n++} END {if(n>0) print sum/n}'
}

alias avgbt=avg_boot_time
alias avg_bt=avg_boot_time

function med_boot_time {
	boot_times \
| awk '
{
    a[NR]=$1
}
END {
    if (NR % 2 == 1)
        print a[(NR+1)/2]
    else
        print (a[NR/2] + a[NR/2+1]) / 2
}'
}

alias medbt=med_boot_time
alias med_bt=med_boot_time

function sd_boot_time {
	grep kernel ~/plots/*.svg \
| grep user \
| sed 's/.*= //g' \
| awk '
{
    n++
    sum += $1
    sumsq += $1 * $1
}
END {
    mean = sum / n
    samp_sd = sqrt((sumsq - n * mean * mean) / (n - 1))

    if (n > 1)
        print samp_sd
}'
}

alias sdbt=sd_boot_time

function iqr_boot_time {
	grep kernel ~/plots/*.svg \
| grep user \
| sed 's/.*= //g' \
| sort -n \
| awk '
{
    a[NR] = $1
}
END {
    n = NR

    # Median helper
    mid = int((n + 1) / 2)

    # Q1 position
    q1_pos = int((n + 1) * 0.25)
    if (q1_pos < 1) q1_pos = 1

    # Q3 position
    q3_pos = int((n + 1) * 0.75)
    if (q3_pos < 1) q3_pos = 1

    q1 = a[q1_pos]
    q3 = a[q3_pos]

    print q3 - q1
}'
}

alias ibt=iqr_boot_time

function stat_boot_time {
	grep kernel ~/plots/*.svg \
| grep user \
| sed 's/.*= //g' \
| sort -n \
| awk '
{
    a[NR]=$1
    sum+=$1
    sumsq+=$1*$1
}
END {
    n=NR
    mean=sum/n

    # Median
    if (n%2)
        median=a[(n+1)/2]
    else
        median=(a[n/2]+a[n/2+1])/2

    # Quartiles (simple method)
    q1=a[int((n+1)*0.25)]
    q3=a[int((n+1)*0.75)]
    iqr=q3-q1

    # Standard deviations
    samp_sd=(n>1)?sqrt((sumsq-n*mean*mean)/(n-1)):"NA"

    print "Count:", n
    print "Mean:", mean
    print "Median:", median
    print "Q1:", q1
    print "Q3:", q3
    print "IQR:", iqr
    print "Sample SD:", samp_sd
}'
}

alias sbt=stat_boot_time

function plot_boot_times {
	grep kernel ~/plots/*.svg \
| grep user \
| sed 's/.*= //g' \
> ~/lfs-scripts/boots.dat
	sed -e "s|Linux From Scratch|$(os-release)|g" \
		-e "s|boot time distribution|boot time distribution as of ${timestamp}.|g" ~/lfs-scripts/hist.gnuplot > ~/lfs-scripts/hist.tmp.gnuplot
	gnuplot ~/lfs-scripts/hist.tmp.gnuplot
	rm ~/lfs-scripts/hist.tmp.gnuplot
	if [[ $XDG_CURRENT_DESKTOP == "KDE" ]]; then
		IMAGE_EDITOR=gwenview
	elif [[ $XDG_CURRENT_DESKTOP == "GNOME" ]]; then
		IMAGE_EDITOR=eog
	fi
	$IMAGE_EDITOR ~/lfs-scripts/boots_hist.png
}

alias pbts=plot_boot_times

export QT6PREFIX=/opt/qt6


# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/fusion809/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<
function clipf {
	if [[ $XDG_SESSION_TYPE == "x11" ]]; then
		xclip -sel clip < "$@"
	else
		cat "$@" | wl-copy
	fi
}

function pip_update {
	sudo pip3 install --upgrade pyparsing attrs numpy sphinx pyqt-builder pyopengl sip pyqt6-sip
}

function cdlfp {
	cd ~/lfs_packaging/$1
}

alias cdlp=cdlfp

function instLfp {
	if [[ -d $HOME/lfs_packaging/$1 ]]; then
		cdlp "$1"
		./build.sh
	fi
}

function Reval {
	R -q -e "$@" | grep "\[1\] " | cut -d ' ' -f 2
}

function percPlasm {
	lines=$(cat /sources/archives/plasma*.md5 | grep -v "^#")
	linesno=$(echo $lines | wc -l)

	Reval "($(echo $lines | grep -B 100 "$1" | wc -l)-1)/$linesno"
}

function vsd {
	sudo vim /etc/sddm.conf
}

function mvOutliers {
R --vanilla -q <<'EOF'

# Define directory explicitly
plot_dir <- path.expand("~/plots")

# Get full file paths
files <- list.files(plot_dir, pattern="\\.svg$", full.names=TRUE)

# Function to extract boot time
get_time <- function(f) {
  lines <- readLines(f, warn = FALSE)

  line <- lines[grepl("Startup finished in", lines)]

  if (length(line) == 0) return(NA_real_)

  # Extract the final total time after '='
  val <- sub(".*= ([0-9.]+)s.*", "\\1", line)

  as.numeric(val)
}
times <- sapply(files, get_time)

# Remove NAs
valid <- !is.na(times)
files <- files[valid]
times <- times[valid]

# Statistics
median_x <- median(times)
iqr_x <- IQR(times)

fac <- 2.5
lower <- median_x - fac*iqr_x
upper <- median_x + fac*iqr_x

cat("n =", length(times), "\n")
cat("median =", median_x, "\n")
cat("IQR =", iqr_x, "\n")
cat("lower bound =", lower, "\n")
cat("upper bound =", upper, "\n")

# Identify outliers
outlier_idx <- which(times < lower | times > upper)
outlier_files <- files[outlier_idx]

cat("\nOutlier files:\n")
print(outlier_files)

# Create outliers directory inside ~/plots
out_dir <- file.path(plot_dir, "outliers")
dir.create(out_dir, showWarnings = FALSE)

# Move files
file.rename(outlier_files,
            file.path(out_dir, basename(outlier_files)))

cat("\nMoved", length(outlier_files), "files to", out_dir, "\n")

EOF
}

read uptime_seconds _ < /proc/uptime

if (( uptime_seconds <= 5 )); then
	mvOutliers
fi

function strip_system {
	sudo su -c 'save_usrlib="$(cd /usr/lib; ls ld-linux*[^g])
             libc.so.6
             libthread_db.so.1
             libquadmath.so.0.0.0
             libstdc++.so.6.0.34
             libitm.so.1.0.0
             libatomic.so.1.2.0"

cd /usr/lib

for LIB in $save_usrlib; do
    objcopy --only-keep-debug --compress-debug-sections=zstd $LIB $LIB.dbg
    cp $LIB /tmp/$LIB
    strip --strip-debug /tmp/$LIB
    objcopy --add-gnu-debuglink=$LIB.dbg /tmp/$LIB
    install -vm755 /tmp/$LIB /usr/lib
    rm /tmp/$LIB
done

online_usrbin="bash find strip"
online_usrlib="libbfd-2.45.1.so
               libsframe.so.2.0.0
               libhistory.so.8.3
               libncursesw.so.6.6
               libm.so.6
               libreadline.so.8.3
               libz.so.1.3.1
               libzstd.so.1.5.7
               $(cd /usr/lib; find libnss*.so* -type f)"

for BIN in $online_usrbin; do
    cp /usr/bin/$BIN /tmp/$BIN
    strip --strip-debug /tmp/$BIN
    install -vm755 /tmp/$BIN /usr/bin
    rm /tmp/$BIN
done

for LIB in $online_usrlib; do
    cp /usr/lib/$LIB /tmp/$LIB
    strip --strip-debug /tmp/$LIB
    install -vm755 /tmp/$LIB /usr/lib
    rm /tmp/$LIB
done

for i in $(find /usr/lib -type f -name \*.so* ! -name \*dbg) \
         $(find /usr/lib -type f -name \*.a)                 \
         $(find /usr/{bin,sbin,libexec} -type f); do
    case "$online_usrbin $online_usrlib $save_usrlib" in
        *$(basename $i)* )
            ;;
        * ) strip --strip-debug $i
            ;;
    esac
done

unset BIN LIB save_usrlib online_usrbin online_usrlib'
}

function cdlfa {
	cd ~/lfs_apps/$1
}


# lfs_autobuild: run the host's latest lfs-autobuild.sh (synced to ~/.lfs_autobuild.sh by the host)
autobuild() {
    bash ~/.lfs_autobuild.sh "$@"
}

missing_search() {
    local pattern="${1:-not found}"

    for i in /usr/lib/* /usr/bin/*; do
        [[ -e "$i" ]] || continue

        if file -L "$i" | grep -q 'ELF'; then
            if ldd "$i" 2>/dev/null | grep -q "$pattern"; then
                echo "$i"
            fi
        fi
    done
}

missing_search_fast() {
    local pattern="${1:-not found}"
    find /usr/lib /usr/bin /opt/qt6/bin /opt/qt6/lib /opt/rustc/bin /opt/rustc/lib /opt/texlive/2025/bin /opt/texlive/2025/lib -type f -print0 |
    while IFS= read -r -d '' f; do
        ldd "$f" 2>/dev/null | grep -q "$pattern" && printf '%s\n' "$f"
    done
}

function version {
	if [[ -n "$1" ]]; then
		pushd $LFS/"$1"
	fi
	eval "$(grep '^version=' build.sh)"
	echo "$version"
	if [[ -n "$1" ]]; then
		popd
	fi
}

function check_version {
	if [[ -n "$1" ]]; then
		name="$1"
		pushd $LFS/"$1"
	else
		name=$(pwd | sed 's|.*/||g')
	fi
	eval "$(grep '^version=' build.sh)"
	inst_version="$(cat /var/lib/lfs-custom-packages/$name)"
	if [[ "$inst_version" != "$version" ]]; then
		echo "Installed version = $inst_version"
		echo "Upstream version  = $version"
	fi
	if [[ -n "$1" ]]; then
		popd
	fi
}

source ~/.lfs_scripts/lfs-vm-bootstrap.sh 2>/dev/null
source ~/.lfs_scripts/lfs-vm-bootstrap.sh 2>/dev/null

cleanup_old_libraries_gpt() {
    local dep_cache="/tmp/lfs_dep_cache.txt"
    local pkg_cache="/tmp/lfs_pkg_cache.txt"
    
    echo "[LFS-AUTOBUILD] Generating comprehensive dependency and package caches..."
    
    # 1. Generate system-wide dependency cache (File -> Shared Lib SONAMEs)
    # We store the SONAMEs that binaries link against.
    find /usr/bin /usr/lib /lib /opt -type f \( -executable -o -name "*.so*" \) 2>/dev/null | 
    xargs -P$(nproc) -I{} sh -c "readelf -d '{}' 2>/dev/null | grep -q '(NEEDED)' && printf '%s: ' '{}' && readelf -d '{}' 2>/dev/null | grep '(NEEDED)' | sed -E 's/.*\[(.*)\].*/\1/' | tr '\n' ' ' && echo" > "$dep_cache"
    
    # 2. Generate package inventory mapping (File -> Package)
    # Ensure we catch ALL files by using a robust grep
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
        echo "------------------------------------------------"
        echo "Evaluating: $i"

        # Check for symbolic link target protection
        if [ -n "$(find /usr/lib /lib -maxdepth 1 -type l -ls 2>/dev/null | grep -w "$(basename "$i")")" ]; then
            echo "Result: Skipping (targeted by a symlink)."
            continue
        fi

        # 4. GET SONAME OF THE LIBRARY
        # This is critical because binaries link against SONAME, not the full file name.
        local soname=$(readelf -d "$i" 2>/dev/null | grep SONAME | sed -E 's/.*\[(.*)\].*/\1/')
        [ -z "$soname" ] && soname=$(basename "$i")
        
        echo "SONAME: $soname"

        # 5. Dependency check using SONAME
        local deps=($(grep -F " $soname " "$dep_cache" | cut -d: -f1))

        if [ ${#deps[@]} -eq 0 ]; then
            # Safe to delete ONLY if NO binaries link against this SONAME
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
                 # If not in inventory, we MUST NOT delete the library.
                 echo "Warning: Dependent binary $d is NOT recorded in any package inventory."
                 echo "Result: Blocking deletion of $i for safety."
                 continue 2
            fi
        done
        
        local pkgs=($(printf "%s\n" "${found_pkgs[@]}" | sort -u))
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
                 # Check if the file still exists and still links to our SONAME
                 if [ -f "$d" ] && readelf -d "$d" 2>/dev/null | grep -q "\[$soname\]"; then
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

export CP=/var/lib/custom-packages
export BP=/var/lib/book-packages
function cdcp {
	cd $CP/$1
}

function cdbp {
	cd $BP/$1
}

OSYS=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d '"' -f 2 | cut -d '/' -f 1)
function start_agent {
	eval ssh-agent $SHELL
	ssh-add ~/.ssh/aur
 	ssh-add ~/.ssh/id_rsa
}

# Switch to SSH
function gitsw {
	# repo is the name of the repository
	if git remote -v | grep origin &> /dev/null ; then
		repo=$(git remote -v | grep origin | sed 's/.*\///g' | sed 's/.git.*//g' | sed 's/ (fetch)//g' | head -n 1)
		git remote rm origin
	else
		repo=${PWD##*/}
	fi

  	if [[ -n "$1" ]]; then
		git remote add origin git@github.com:fusion809/"${1}".git
	else
		git remote add origin git@github.com:fusion809/"${repo}".git
	fi
}

alias SSH=gitsw
alias gitssh=gitsw
alias gits=gitsw

function gtsa {
	for i in $GHUBM/*/*
	do
		pushd $i || return
		gitsw
		popd || return
	done
}

function update_git_repo {
	if [[ -n "$2" ]]; then
		git -C "$1" pull "$2" $(git-branch "$1") -q
	elif [[ -n "$1" ]]; then
		git -C "$1" pull origin $(git-branch "$1") -q
	else
		git pull origin "$(git-branch)" -q
	fi
}

function current_git_branch {
	if ! [[ -n "$1" ]]; then
		git rev-parse --abbrev-ref HEAD
	else
		git -C "$1" rev-parse --abbrev-ref HEAD
	fi
}

alias git-branch=current_git_branch

function git_checkout {
	git -C "$1" checkout "$2"
}

function latest_commit_number {
	update_git_repo "$1"
	if ! [[ -n "$1" ]]; then
		git rev-list --branches "$(git-branch)" --count
	else
		git -C "$1" rev-list --branches "$(git-branch "$1")" --count
	fi
}

alias comno=latest_commit_number

function pushop {
	if [[ -n "$1" ]]; then
		git push origin "$(git-branch)" "$1"
	else
		git push origin "$(git-branch)"
	fi
}

## Minimal version
function pushm {
	git add --all										# Add all files to git
	git commit -m "$1"								   # Commit with message = argument 1
	pushop										 # Push to the current branch
}

function pushme {
	git add --all
	git commit --edit
	pushop "$1"
}

function pushmf {
	git add --all
	git commit -m "$1"
	git push origin $(git-branch) -f
}

function pusht {
	git add --all
	git commit -m "$1"
	if [[ -n $2 ]]; then
		 git tag "$2"
		 git push origin "$2"
	else
		 git tag "$(latest_commit_number)"
		 git push origin "$(latest_commit_number)"
	fi
	git push origin "$(git-branch)"
}

## Update common-scripts
function cssubup {
	if [[ "$1" = common ]] && ! echo ""$PWD"" | grep "$SCR/common-scripts" > /dev/null 2>&1 && [[ -d "$SCR/$1-scripts" ]] ; then
		 printf "%s\n" "Updating common-scripts repository."
		 pushd "$SCR/$1-scripts" || return
	elif ! [[ "$1" == common ]]; then
		 pushd "$SCR/$1-scripts"/Shell/common-scripts || return
	fi

	git fetch origin
	git merge --no-edit --ff origin/master

	if ! [[ $1 = common ]]; then
		 pushd .. || return
		 pushm "Updating common-scripts submodule"
		 popd || return
	fi

	popd || return
}

function update_common_scripts_repo {
	printf "Updating common-scripts submodules and main repo.\n"
	cssubup arch
	cssubup centos
	cssubup common
	cssubup debian
	cssubup fedora
	cssubup gentoo
	cssubup mageia
	cssubup nixos
	cssubup opensuse
	cssubup pclinuxos
	cssubup pisi
	cssubup sabayon
	cssubup slackware
	cssubup solus
	cssubup void
}

alias update-common=update_common_scripts_repo

# Complete push
function push {
	if [[ -d .git ]] || ( git log &> /dev/null ); then
		if printf "$PWD" | grep 'AUR' > /dev/null 2>&1 ; then
			 mksrcinfo
		fi

		if echo "$PWD" | grep opendesktop > /dev/null 2>&1 ; then
			 commc=$(git rev-list --branches master --count)
			 commn=$(octave_evaluate "$commc+1")
			 sed -i -e "s/PKGVER=[0-9]*/PKGVER=${commn}/g" "$PK"/opendesktop-app/pkg/appimage/appimagebuild
			 pushm "$1"
		else
			 pushm "$1"
		fi

		if echo "$PWD" | grep "$HOME/Shell" > /dev/null 2>&1 ; then
			 szsh
		elif echo "$PWD" | grep "$FS" > /dev/null 2>&1 && grep -i Fedora < /etc/os-release > /dev/null 2>&1 ; then
			 szsh
		elif echo "$PWD" | grep "$ARS" > /dev/null 2>&1 && grep -i Arch < /etc/os-release  > /dev/null 2>&1 ; then
			 szsh
		elif echo "$PWD" | grep "$GS" > /dev/null 2>&1 && grep -i Gentoo < /etc/os-release > /dev/null 2>&1; then
			 szsh
		elif echo "$PWD" | grep "$DS" > /dev/null 2>&1 && grep -i "Debian\|Ubuntu" < /etc/os-release > /dev/null 2>&1; then
			 szsh
		elif echo "$PWD" | grep "$VS" > /dev/null 2>&1 && grep -i Void < /etc/os-release > /dev/null 2>&1; then
			 szsh
		elif echo "$PWD" | grep "$OSS" > /dev/null 2>&1 && grep -i openSUSE < /etc/os-release > /dev/null 2>&1; then
			 szsh
		elif echo "$PWD" | grep "$NS" > /dev/null 2>&1 && grep -i NixOS < /etc/os-release > /dev/null 2>&1; then
			 szsh
		elif echo "$PWD" | grep "$PLS" > /dev/null 2>&1 && grep -i PCLinuxOS < /etc/os-release > /dev/null 2>&1; then
			 szsh
		elif echo "$PWD" | grep "$CS" > /dev/null 2>&1 && grep -i CentOS < /etc/os-release > /dev/null 2>&1; then
			 szsh
		fi

		# Update common-scripts dirs
		if echo "$PWD" | grep "common-scripts" > /dev/null 2>&1; then
			 if ! echo "$SHELL" | grep zsh > /dev/null 2>&1; then
				  read -p "Do you want to update common-scripts submodules and the main common-scripts repo (if not already up-to-date) now? [y/n] " yn
			 else
				  read "yn?Do you want to update common-scripts submodules and the main common-scripts repo (if not already up-to-date) now? [y/n] "
			 fi

			 case $yn in
				  [Yy]* ) update-common;;
				  [Nn]* ) printf "%s\n" "OK, it's your funeral. Run update-common if you change your mind." ;;
				  * ) printf "%s\n" "Please answer y or n." ; ...
			 esac
		fi
	elif [[ -d .osc ]]; then
		osc ci -m "$@"
	fi
}

# Complete push, but with potentially more detailed commit message
function pushe {
	if printf "$PWD" | grep 'AUR' > /dev/null 2>&1 ; then
		 mksrcinfo
	fi

	if echo "$PWD" | grep opendesktop > /dev/null 2>&1 ; then
		 commc=$(git rev-list --branches master --count)
		 commn=$(octave_evaluate "$commc+1")
		 sed -i -e "s/PKGVER=[0-9]*/PKGVER=${commn}/g" "$PK"/opendesktop-app/pkg/appimage/appimagebuild
		 pushme "$1"
	elif echo "$PWD" | grep OpenRA > /dev/null 2>&1 ; then
		 commc=$(git rev-list --branches bleed --count)
		 commn=$(octave_evaluate "$commc+1")
		 sed -i -e "s/COMNO=[0-9]*/COMNO=${commn}/g" "$PK"/OpenRA/packaging/linux/buildpackage.sh
		 pushme "$1"
	else
		 pushme "$1"
	fi

	if echo "$PWD" | grep "$HOME/Shell" > /dev/null 2>&1 ; then
		 szsh
	elif echo "$PWD" | grep "$FS" > /dev/null 2>&1 && grep -i Fedora < /etc/os-release > /dev/null 2>&1 ; then
		 szsh
	elif echo "$PWD" | grep "$ARS" > /dev/null 2>&1 && grep -i Arch < /etc/os-release  > /dev/null 2>&1 ; then
		 szsh
	elif echo "$PWD" | grep "$GS" > /dev/null 2>&1 && grep -i Gentoo < /etc/os-release > /dev/null 2>&1; then
		 szsh
	elif echo "$PWD" | grep "$DS" > /dev/null 2>&1 && grep -i "Debian\|Ubuntu" < /etc/os-release > /dev/null 2>&1; then
		 szsh
	elif echo "$PWD" | grep "$VS" > /dev/null 2>&1 && grep -i Void < /etc/os-release > /dev/null 2>&1; then
		 szsh
	elif echo "$PWD" | grep "$OSS" > /dev/null 2>&1 && grep -i openSUSE < /etc/os-release > /dev/null 2>&1; then
		 szsh
	elif echo "$PWD" | grep "$NS" > /dev/null 2>&1 && grep -i NixOS < /etc/os-release > /dev/null 2>&1; then
		 szsh
	elif echo "$PWD" | grep "$PLS" > /dev/null 2>&1 && grep -i PCLinuxOS < /etc/os-release > /dev/null 2>&1; then
		 szsh
	elif echo "$PWD" | grep "$CS" > /dev/null 2>&1 && grep -i CentOS < /etc/os-release > /dev/null 2>&1; then
		 szsh
	fi

	# Update common-scripts dirs
	if echo "$PWD" | grep "$HOME/Shell/common-scripts" > /dev/null 2>&1; then
		 if ! echo "$SHELL" | grep zsh > /dev/null 2>&1; then
			  read -p "Do you want to update common-scripts submodules and the main common-scripts repo (if not already up-to-date) now? [y/n] " yn
		 else
			  read "yn?Do you want to update common-scripts submodules and the main common-scripts repo (if not already up-to-date) now? [y/n] "
		 fi

		 case $yn in
			  [Yy]* ) update-common;;
			  [Nn]* ) printf "%s\n" "OK, it's your funeral. Run update-common if you change your mind." ;;
			  * ) printf "%s\n" "Please answer y or n." ; ...
		 esac
	fi
}

# Estimate the size of the current repo
# Taken from http://stackoverflow.com/a/16163608/1876983
function gitsize {
	git gc
	git count-objects -vH
}

# Git shrink
# Taken from http://stackoverflow.com/a/2116892/1876983
function gitsh {
	git reflog expire --all --expire=now
	git gc --prune=now --aggressive
}

function pushss {
	push "$1" && gitsh && gitsize
}

# Complete push
function pushf {
	if printf "$PWD" | grep 'AUR' > /dev/null 2>&1 ; then
		mksrcinfo
	fi

	if echo "$PWD" | grep opendesktop > /dev/null 2>&1 ; then
		commc=$(git rev-list --branches master --count)
		commn=$(octave_evaluate "$commc+1")
		sed -i -e "s/PKGVER=[0-9]*/PKGVER=${commn}/g" "$PK"/opendesktop-app/pkg/appimage/appimagebuild
		pushmf "$1"
	elif echo "$PWD" | grep OpenRA > /dev/null 2>&1 ; then
		commc=$(git rev-list --branches bleed --count)
		commn=$(octave_evaluate "$commc+1")
		sed -i -e "s/COMNO=[0-9]*/COMNO=${commn}/g" "$PK"/OpenRA/packaging/linux/buildpackage.sh
		pushmf "$1"
	else
		pushmf "$1"
	fi

	if echo "$PWD" | grep "$HOME/Shell" > /dev/null 2>&1 ; then
		szsh
	elif echo "$PWD" | grep "$FS" > /dev/null 2>&1 && grep -i Fedora < /etc/os-release > /dev/null 2>&1 ; then
		szsh
	elif echo "$PWD" | grep "$ARS" > /dev/null 2>&1 && grep -i Arch < /etc/os-release  > /dev/null 2>&1 ; then
		szsh
	elif echo "$PWD" | grep "$GS" > /dev/null 2>&1 && grep -i Gentoo < /etc/os-release > /dev/null 2>&1; then
		szsh
	elif echo "$PWD" | grep "$DS" > /dev/null 2>&1 && grep -i "Debian\|Ubuntu" < /etc/os-release > /dev/null 2>&1; then
		szsh
	elif echo "$PWD" | grep "$VS" > /dev/null 2>&1 && grep -i Void < /etc/os-release > /dev/null 2>&1; then
		szsh
	elif echo "$PWD" | grep "$OSS" > /dev/null 2>&1 && grep -i openSUSE < /etc/os-release > /dev/null 2>&1; then
		szsh
	elif echo "$PWD" | grep "$NS" > /dev/null 2>&1 && grep -i NixOS < /etc/os-release > /dev/null 2>&1; then
		szsh
	elif echo "$PWD" | grep "$PLS" > /dev/null 2>&1 && grep -i PCLinuxOS < /etc/os-release > /dev/null 2>&1; then
		szsh
	elif echo "$PWD" | grep "$CS" > /dev/null 2>&1 && grep -i CentOS < /etc/os-release > /dev/null 2>&1; then
		szsh
	fi

	# Update common-scripts dirs
	if echo "$PWD" | grep "$HOME/Shell/common-scripts" > /dev/null 2>&1; then
		if ! echo "$SHELL" | grep zsh > /dev/null 2>&1; then
			read -p "Do you want to update common-scripts submodules and the main common-scripts repo (if not already up-to-date) now? [y/n] " yn
		else
			read "yn?Do you want to update common-scripts submodules and the main common-scripts repo (if not already up-to-date) now? [y/n] "
		fi

		case $yn in
			[Yy]* ) update-common;;
			[Nn]* ) printf "%s\n" "OK, it's your funeral. Run update-common if you change your mind." ;;
			* ) printf "%s\n" "Please answer y or n." ; ...
		esac
	fi
}

function git-changed-list {
	git diff --name-only | awk '
{
    files[NR] = $0
}
END {
    for (i = 1; i <= NR; i++) {
        if (i == 1 && NR == 1)
            printf "%s", files[i]
        else if (i == NR)
            printf " and %s", files[i]
        else if (i == 1)
            printf "%s", files[i]
        else
            printf ", %s", files[i]
    }
    print ""
}'
}

function packages_push {
	if ! [[ -n "$1" ]]; then
		push "$(git-changed-list): file list"
	else
		push "$(git-changed-list): $1"
	fi
}

function list_fileless {
	if ! ( [[ $(pwd) == "/var/lib/book-packages" ]] || [[ $(pwd) == "/var/lib/custom-packages" ]] ) ; then
		cdbp
	fi	
	grep -L '/' *
}

function perc_fileless {
	perc=$(Reval "(1-$(grep -L '/' * | wc -l)/$(ls | wc -l))*100")
	echo "$perc% of packages have file lists"
}

function pstart {
	ps -eo pid,lstart | grep  "$1" | sed "s/\s*$1 //g"
}

function pelaps {
	t1=$(date -d "$(pstart "$1")" +"%s")
	t2=$(date +"%s")
	s=$((t2-t1))
	printf '%02d:%02d:%02d\n' $(($s/3600)) $((($s%3600)/60)) $(($s%60))
}

function loop_pelaps {
	while ps ax | grep "$1" &> /dev/null;
	do
		dur=$(pelaps "$1")
		echo "$1 has taken $dur..."
		sleep 1
	done
	echo "Took a total of $dur for $1 to finish..."
}

function pelaps_live {
    local pid_or_name="$1"
    local start_str=$(pstart "$pid_or_name" | head -n 1)
    
    if [[ -z "$start_str" ]]; then
        echo "No process matching '$pid_or_name' found."
        return 1
    fi
    
    local t1=$(date -d "$start_str" +"%s")
    
    # Trap to ensure cursor is restored on Ctrl+C
    trap "printf '\e[?25h\n'; return" INT
    
    # Hide cursor
    printf "\e[?25l"

    while true; do
        # Check if process is still alive
        local alive=false
        if [[ "$pid_or_name" =~ ^[0-9]+$ ]]; then
            kill -0 "$pid_or_name" 2>/dev/null && alive=true
        else
            pgrep -f "$pid_or_name" >/dev/null 2>&1 && alive=true
        fi
        
        local t2=$(date +"%s")
        local s=$((t2-t1))
        
        # Print time with carriage return
        printf "\r%02d:%02d:%02d" $(($s/3600)) $((($s%3600)/60)) $(($s%60))
        
        if [[ "$alive" == "false" ]]; then
            # Print one last time and exit
            printf "\n"
            break
        fi
        
        sleep 1
    done
    
    # Restore cursor
    printf "\e[?25h"
    trap - INT
}
# Monitoring function for a single autobuild process
# Monitoring function for a single autobuild process
function elaps_build {
    local line=$(ps -eo pid,args | grep "autobuild.sh" | grep -v grep | head -n 1)
    if [[ -z "$line" ]]; then
        echo "Error: No active autobuild process found."
        return 1
    fi
    
    local pid=$(echo "$line" | awk '{print $1}')
    # Get the package name (the last argument of the command line)
    local pkg=$(echo "$line" | grep -oP '(?<=autobuild\.sh\s)\S+')
    
    echo "------------------------------------------------"
    echo "Currently building: $pkg (PID: $pid)"
    pelaps_live "$pid"
}

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

function update-grub {
	sudo /sbin/grub-mkconfig -o /boot/grub/grub.cfg
}
