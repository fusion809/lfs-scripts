#!/bin/bash
cat ~/packages_no_long.log
pip=$(pip3 list | wc -l)
book=$(ls /var/lib/book-packages | wc -l)
custom=$(ls /var/lib/custom-packages | wc -l)
R=$(Rscript -e 'ip <- installed.packages(); cat(ip[,1], sep="\n")' | wc -l)
julia=$(julia -e 'using Pkg; Pkg.status()' | wc -l)
total=$(($julia+$pip+$R+$book+$custom))
function comno {
    git -C /var/lib/$1-packages rev-list --branches master --count
}
BP=$(comno book)
CP=$(comno custom)
echo "$total [ $book (󰊢 ${BP})  $custom (󰊢 $CP)  $julia  $pip  $R]" > ~/packages_no_long.log
