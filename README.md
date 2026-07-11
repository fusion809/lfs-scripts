# LFS scripts
This repository contains the shell scripts I use on Linux From Scratch. The check-updates.sh script is a script to determine whether the versions of each package in my LFS VM are outdated. It refers to functions.sh. The zshrc file, Shell folder and root folder contain the scripts I place in ~/, ~/Shell and /root, respectively on my LFS system to make my life on LFS easier. 

The scripts used by my [Executor GNOME extension setup](https://github.com/fusion809/executor-raujonas.github.io) are explained in Table 1.

**Table 1: Scripts used by Executor GNOME extension.**
| Script                | Description |
|-----------------------|-------------|
| `count-wallpapers.sh` | Displays 󰸉 number of displayed wallpaper/total number of wallpapers. |
| `list-wallpaper.sh`   | Lists wallpapers with the displayed one highlighted and in the centre of the screen. |
| `open-wallpaper.sh`   | Open displayed wallpaper in EOG. |
| `update-table.sh`     | Produces table of package updates, packages with missing inventories, and packages with failed versioning. |
| `updates_no.sh`       | Prints `$in_progress $mod_time  $no_updates 󰂕 $no_missing_total  $no_failed` where:
* `$in_progress` is replaced with `󰦕 ` if an update check is in progress.
* `$mod_time` is when the most recent update check finished. 
* `$no_updates` is the number of available updates.
* `$no_missing_total` is the number of packages with missing inventories.
* `$no_failed` is the number of packages with failed versioning checks. |
