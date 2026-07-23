# LFS scripts
This repository contains the shell scripts I use on Linux From Scratch. The check-updates.sh script is a script to determine whether the versions of each package in my LFS VM are outdated. It refers to functions.sh. The zshrc file, Shell folder and root folder contain the scripts I place in ~/, ~/Shell and /root, respectively on my LFS system to make my life on LFS easier. 

The scripts used by my [Executor GNOME extension setup](https://github.com/fusion809/executor-raujonas.github.io) are explained in Table 1.

**Table 1: Scripts used by Executor GNOME extension.**
<table>
<thead>
<tr>
<th>Script</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>count-wallpapers.sh</code></td>
<td>Displays 󰸉 number of displayed wallpaper/total number of wallpapers.</td>
</tr>
<tr>
<td><code>list-wallpaper.sh</code></td>
<td>Lists wallpapers with the displayed one highlighted and in the centre of the screen.</td>
</tr>
<tr>
<td><code>open-wallpaper.sh</code></td>
<td>Open displayed wallpaper in EOG.</td>
</tr>
<tr>
<td><code>update-table.sh</code></td>
<td>Produces table of package updates, packages with missing inventories, and packages with failed versioning.</td>
</tr>
<tr>
<td><code>updates_no.sh</code></td>
<td>Prints <code>$in_progress  $mod_time  $no_updates 󰂕 $no_missing_total  $no_failed</code> where:
<ul>
<li><code>$in_progress</code> is replaced with <code>󰦕$perc_elapsed </code> if an update check is in progress. <code>$perc_elapsed</code> is replaced with the percentage of time in the update check job that's elapsed.</li>
<li><code>$mod_time</code> is when the most recent update check finished. </li>
<li><code>$no_updates</code> is the number of available updates.</li>
<li><code>$no_missing_total</code> is the number of packages with missing inventories.</li>
<li><code>$no_failed</code> is the number of packages with failed versioning checks.</li>
</ul></td>
</tr>
<tr>
<td><code>updates_no_funcs.sh</code></td>
<td>Provides functions used by <code>updates_no.sh</code>.</td>
</tr>
</tbody>
</table>