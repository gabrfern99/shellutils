#!/bin/bash

# RENAME MULTIPLE FILES IN DIR TO A COMMON EXTENSION
# *.JPG -> *.jpg


# FUNCTION NOT WORKING, THE 'toext' variable is not being
# readed in the sh -c '...' part
function OTNext()
{
	echo -n "Directory: "
	read -r dir
	echo -n "From extension (zip, bz2, jpeg, ...): "
	read -r frext
	echo -n "To extension: "
	read -r toext
	# TESTING
	find "$dir" -name "*.$frext" -exec sh -c "for f; do echo "$f" "${f%.*}.${toext}"; done" {} +

}

echo "Function description - Function Name"
echo "Old ext to new ext - OTNext"
echo ""

if [ $# -ne 1 ]; then
	echo "Usage: shutils.sh funcname"
	exit
	fi

if [[ $1 == "OTNext" ]]; then
	OTNext
else
	echo "No function with that name"
	exit
fi
