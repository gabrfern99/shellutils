#!/bin/bash

# A simple shell script to backup personal config files given a wordlist of them

BACKUPDIR="$1"
BACKUPFILE="$2"

function createBackupDir()
{
    if [ ! -d "$BACKUPDIR" ]; then
	echo "Creating user initial backup directory"
	mkdir "$BACKUPDIR"
    fi
}

function backupItens()
{
    while read itens; do
	for iten in "$itens"; do
	    filteredItem="$(basename $iten)"
	    if [[ -d "$BACKUPDIR$filteredItem" || -f "$BACKUPDIR$filteredItem" ]]; then
		continue
	    else
		rsync -avh "$iten" "$BACKUPDIR" 2> /dev/null
	    fi
	done
    done < <(grep . "$BACKUPFILE")

}

function checkChangedItens()
{
    while read itens; do
	for iten in "$itens"; do
	    filteredItem="$(basename $iten)"
	    if [[ $(diff -qr "$iten" "$BACKUPDIR$filteredItem" 2>/dev/null) ]]; then
		rsync -avh "$iten" "$BACKUPDIR" 2> /dev/null
	    else
		continue
	    fi
	done
    done < <(grep . "$BACKUPFILE")
}

function main()
{
    createBackupDir
    if [ -f "$BACKUPFILE" ]; then
	backupItens
	checkChangedItens
    else
	echo "No file with itens to backup"
	exit 1
    fi
}

if [ $# -ne 2 ]; then
    echo "Usage: backupdir backupfile"
    exit 1
else
    main
fi
