#!/bin/bash
cat ~/inventory_commit_no_long.log
function comno {
    git -C /var/lib/$1-packages rev-list --branches master --count
}
BP=$(comno book)
CP=$(comno custom)
echo "󰏗 󰊢   $BP  $CP" > ~/inventory_commit_no_long.log