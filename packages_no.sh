#!/bin/bash
pip=$(pip3 list | wc -l)
book=$(ls /var/lib/book-packages | wc -l)
custom=$(ls /var/lib/custom-packages | wc -l)
R=$(Rscript -e 'ip <- installed.packages(); cat(ip[,1], sep="\n")' | wc -l)
julia=$(julia -e 'using Pkg; Pkg.status()' | wc -l)
total=$(($julia+$pip+$R+$book+$custom))
echo "$total (󰌽 $book,  $custom,  $julia,  $pip,  $R)"
