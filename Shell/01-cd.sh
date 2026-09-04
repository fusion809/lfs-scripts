function cda {
	cd $ARC/$1
}

function cdap {
	cd ~/.local/share/applications
}

function cdbp {
	cd $BP/$1
}

function cdcp {
	cd $CP/$1
}

function cddo {
	cd $HOME/Downloads
}

function cde {
	cd /usr/share/gnome-shell/extensions/executor@raujonas.github.io/$1
}

function cdi {
	cd ~/.local/share/icons/$1
}

function cdl {
	cd ~/logs/$1
}

function cdld {
	cd ~/lfs_dotfiles/$1
}

function cdle {
	cd ~/.local/share/gnome-shell/extensions/$1
}

function cdlfa {
	cd ~/lfs_apps/$1
}

function cdlfp_base {
	cd ~/lfs_packaging/$1
}
function cdlfp {
	if [[ -d ~/lfs_packaging/$1 ]]; then
		cdlfp_base $1
	else
		mkdir -p ~/lfs_packaging/$1
		cdlfp_base $1
		cat > build.sh <<EOF
#!/bin/bash
set -e
name=$1
version=
filename="\$name-\$version.tar.gz"
direname="\${filename/.tar.*/}"
if ! [[ -f \$filename ]]; then
	wget -c
fi
rm -rf "\$direname"
tar xf "\$filename"
cd "\$direname"
rm -rf "\$filename" "\$direname"
echo "\$version" | sudo tee "/var/lib/custom-packages/\$name"
EOF
		chmod +x build.sh
		echo "build.sh created but almost empty"
	fi
}

alias cdlp=cdlfp

function cdlfs {
	cd ~/lfs-scripts/$1
}

function cdlg {
	cd ~/lfs_gnuplot/$1
}

function cdp {
	cd ~/plots/$1
}

function cdps {
	cd ~/Screenshots/$1
}

function cds {
	cd $SRC/$1
}

function cdsap {
	cd /usr/share/applications
}

function cdsh {
	cdlfs "Shell/$1"
}

function cdw {
	cd ~/wallpapers
}

