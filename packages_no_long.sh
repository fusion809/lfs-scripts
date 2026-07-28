#!/bin/bash
cat ~/packages_no_long.log
if find ~/packages_no_long.log -mmin +5 | grep -q .; then
	pip=$(pip3 list | wc -l)
	book=$(ls /var/lib/book-packages | wc -l)
	custom=$(ls /var/lib/custom-packages | wc -l)
	R=$(Rscript -e 'ip <- installed.packages(); cat(ip[,1], sep="\n")' | wc -l)
	julia=$(julia -e 'using Pkg; Pkg.status()' | wc -l)
	if (( $julia == 0 )); then
		julia="1"
	fi
	total=$(($julia+$pip+$R+$book+$custom))
	function comno {
	    git -C /var/lib/$1-packages rev-list --branches master --count
	}
	BP=$(comno book)
	CP=$(comno custom)
	echo "$total [ $book (󰊢 ${BP})  $custom (󰊢 $CP)  $julia  $pip  $R]" > ~/packages_no_long.log
fi
