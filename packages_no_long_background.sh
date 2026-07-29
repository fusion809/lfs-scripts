#!/bin/bash
function hash {
	git -C /var/lib/$1-packages rev-parse --short HEAD
}

function stHash {
	cat ~/$1_hash.log
}

function nopkg {
	ls /var/lib/$1-packages | wc -l
}

function comno {
	git -C /var/lib/$1-packages rev-list --branches master --count
}

BH=$(hash book);
BN=$(nopkg book);
BP=$(comno book);
CH=$(hash custom);
CN=$(nopkg custom);
CP=$(comno custom); 

if [[ $BH != "$(stHash book)" ]] || [[ $CH != "$(stHash custom)" ]]; then
	pip=$(pip3 list | wc -l)
	R=$(Rscript -e 'ip <- installed.packages(); cat(ip[,1], sep="\n")' | wc -l)
	julia=$(julia -e 'using Pkg; Pkg.status()' | wc -l)
	if (( $julia == 0 )); then
		julia="1"
	fi
	total=$(($julia+$pip+$R+$BN+$CN))
	echo "$total [ $BN (󰊢 ${BP})  $CN (󰊢 $CP)  $julia  $pip  $R]" > ~/packages_no_long.log
fi
echo "$BH" > ~/book_hash.log
echo "$CH" > ~/custom_hash.log
