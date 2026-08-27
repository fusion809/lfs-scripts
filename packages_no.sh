#!/bin/bash
cat ~/logs/packages_no.log
pip=$(pip3 list | wc -l)
book=$(ls /var/lib/book-packages | wc -l)
custom=$(ls /var/lib/custom-packages | wc -l)
R=$(Rscript -e 'ip <- installed.packages(); cat(ip[,1], sep="\n")' | wc -l)
julia=$(julia -e 'using Pkg; Pkg.status()' | wc -l)
if (( $julia == 0 )); then
	julia="1"
fi
total=$(($julia+$pip+$R+$book+$custom))
echo "$total [ $book,  $custom,  $julia,  $pip,  $R]" > ~/logs/packages_no.log
