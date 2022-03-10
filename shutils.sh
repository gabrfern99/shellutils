#!/bin/bash

# RENAME MULTIPLE FILES IN DIR TO A COMMON EXTENSION
# *.JPG -> *.jpg
function old_to_new_ext()
{
	read -p "Full directory path: " dir
	read -p "From extension (zip, bz2, jpeg, ...): " frext
	read -p "To extension: " toext

	frextfiles="$(find "${dir}" -name "*.${frext}")"
	for file in $frextfiles; do
	    mv "$file" "${file%.*}.${toext}";
	done
	exit 0
}
# Function that cut away part of a long file name
# and preserves extension
function cut_long_fname()
{
	echo -n "Full directory path: "
	read -r dir

	find "$dir" -type f > /tmp/tmpfnames
	n=0
	while read -r fname; do
		fext="${fname##*.}"
		if [ "${#fname}" -gt 244 ]; then
			n=$((n+1))
			nfname=${fname:0:240}
			mv "$fname" "$nfname.$fext"
		else
			continue
		fi
	done < /tmp/tmpfnames

	echo ''
	echo "$n items renamed"
	rm /tmp/tmpfnames
	exit 0
}

echo "Function description - Function Name"
echo "Old ext to new ext - old_to_new_ext"
echo "Cut long file names - cut_long_fname"
echo ""

if [ $# -ne 1 ]; then
	echo "Usage: shutils.sh funcname"
	exit 1
fi

if [[ $1 == "old_to_new_ext" ]]; then
	old_to_new_ext
elif [[ $1 == "cut_long_fname" ]]; then
	cut_long_fname
else
	echo "No function with that name"
	exit 1
fi
