function update-grub {
	sudo /sbin/grub-mkconfig -o /boot/grub/grub.cfg
}

function szsh {
	source $HOME/.zshrc
}

ver=$(wget -cqO- https://www.linuxfromscratch.org/lfs/view/systemd/index.html | grep -i "version" | sed 's/^\s*//g' | cut -d ' ' -f 2 | sed 's/-systemd//g')
function upos {
	upver=$(wget -cqO- https://www.linuxfromscratch.org/lfs/view/systemd/index.html | grep "Version" | sed 's/^\s*//g' | cut -d ' ' -f 2 | sed 's/-systemd//g')
	if echo "$upvar" | grep "^r"; then
		sudo sed -i -E "s|r[0-9]{2,}\.[0-9]-[0-9]+|$upver|g" /etc/os-release /etc/lfs-release /etc/lsb-release
	fi
}

if [[ $ver != $(cat /etc/os-release | grep VERSION_ID | cut -d '"' -f 2) ]]; then
	upos
fi

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

