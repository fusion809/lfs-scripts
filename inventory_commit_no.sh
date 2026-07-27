#!/bin/bash
function comno {
    git -C /var/lib/$1-packages rev-list --branches master --count
}
BP=$(comno book)
CP=$(comno custom)
echo "  $BP  $CP"