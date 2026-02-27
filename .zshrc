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
for i in $HOME/Shell/*.sh
do
  . "$i"
done

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
export PATH=$PATH:/opt/rustc/bin:/opt/jdk/bin:/opt/qt6/bin:/opt/texlive/2025/bin/x86_64-linux
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
	cd ~/plots
}

function cdps {
	cd ~/Screenshots
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
	cat ~/plots/$timestamp.svg \
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

lines=$(cat /sources/archives/plasma-6.6.1.md5 | grep -v "^#")
linesno=$(echo $lines | wc -l)

function percPlasm {
	R -q -e "($(echo $lines | grep -B 100 "$1" | wc -l)-1)/$linesno" | grep "\[1\] " | cut -d ' ' -f 2
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
  line  <- lines[grepl("user", lines) & grepl("kernel", lines)]
  as.numeric(sub(".*= ", "", line))
}

times <- sapply(files, get_time)

# Remove NAs
valid <- !is.na(times)
files <- files[valid]
times <- times[valid]

# Statistics
median_x <- median(times)
iqr_x <- IQR(times)

lower <- median_x - 1.5*iqr_x
upper <- median_x + 1.5*iqr_x

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
