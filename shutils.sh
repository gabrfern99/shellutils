#!/bin/bash


usage ()
{
    echo "Function description - Function Name"
    echo "Old ext to new ext - old_to_new_ext"
    echo "Cut long file names - cut_long_fname"
    echo ""
    echo "$0 -d <Directory path> -f <Function name>"
    exit 0
}
# RENAME MULTIPLE FILES IN DIR TO A COMMON EXTENSION
# *.JPG -> *.jpg
function old_to_new_ext()
{
	read -p "Current file extension: " frext
	read -p "To file extension: " toext

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

[ $# -eq 0 ] && usage
while getopts "hd:f:" arg; do
    case $arg in
	d)
	    dir="${OPTARG}"
	    ;;
	f)
	    funcname="${OPTARG}"
	    ;;
	h | *)
	    usage
	    ;;
    esac
done

[[ -z $dir || -z $funcname ]] && echo "No directory or function name specified" && exit 1
[[ ! -d $dir ]] && echo "$dir is not a directory" && exit 1
[[ $funcname != "old_to_new_ext" && $funcname != "cut_long_fname" ]] && echo "No function with that name: $funcname" && exit 1
[[ $funcname == "old_to_new_ext" ]] && old_to_new_ext
[[ $funcname == "cut_long_fname" ]] && cut_long_fname

    
