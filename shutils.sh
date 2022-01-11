#!/bin/bash

# RENAME MULTIPLE FILES IN DIR TO A COMMON EXTENSION
# *.JPG -> *.jpg


# FUNCTION NOT WORKING, THE 'toext' variable is not being
# readed in the sh -c '...' part
function OTNext()
{
	echo -n "Full directory path: "
	read -r dir
	echo -n "From extension (zip, bz2, jpeg, ...): "
	read -r frext
	echo -n "To extension: "
	read -r toext
	# TESTING
	find "$dir" -name "*.$frext" -exec sh -c "for f; do echo "$f" "${f%.*}.${toext}"; done" {} +

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
}

echo "Function description - Function Name"
echo "Old ext to new ext - OTNext"
echo "Cut long file names - cut_long_fname"
echo ""

if [ $# -ne 1 ]; then
	echo "Usage: shutils.sh funcname"
	exit
fi

if [[ $1 == "OTNext" ]]; then
	OTNext
elif [[ $1 == "cut_long_fname" ]]; then
	cut_long_fname
else
	echo "No function with that name"
	exit
fi
