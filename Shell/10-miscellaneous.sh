function update-grub {
	sudo /sbin/grub-mkconfig -o /boot/grub/grub.cfg
}

function szsh {
	source $HOME/.zshrc
}

function upos {
	~/.lfs_scripts/upos.sh
}
function srcs {
	sudo du -h --max-depth=0 $SRC/* | sort -h
}

function os-release {
	cat /etc/os-release | grep "PRETTY_NAME" | cut -d '"' -f 2
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

function clipf {
	if [[ $XDG_SESSION_TYPE == "x11" ]]; then
		xclip -sel clip < "$@"
	else
		cat "$@" | wl-copy
	fi
}

OSYS=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d '"' -f 2 | cut -d '/' -f 1)

local_time=$(date +"%a, %d %b %Y %R:%S" -u)
google_time="$(curl -sI https://google.com | grep -i '^date:' | sed 's/^[Dd]ate: //g')"

if [[ "$local_time" != "${google_time/ GMT/}" ]]; then
	sudo date -s "$google_time" > /dev/null
fi

