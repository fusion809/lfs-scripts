#!/bin/bash
function hash {
    git -C /var/lib/$1-packages rev-parse --short HEAD
}
function changes {
	! git -C /var/lib/$1-packages diff --quiet
}
BH=$(hash book);
CH=$(hash custom);

if [[ $BH != "$(cat ~/book_hash.log)" ]] || [[ $CH != "$(cat ~/custom_hash.log)" ]] || changes book || changes custom; then
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
	BP=$(comno book);
	CP=$(comno custom); 
	echo "$total [ $book (󰊢 ${BP})  $custom (󰊢 $CP)  $julia  $pip  $R]" > ~/packages_no_long.log
fi
echo "$BH" > ~/book_hash.log
echo "$CH" > ~/custom_hash.log
