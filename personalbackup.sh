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
    while IFS= read -r iten; do
	    rsync -avh "$iten" "$BACKUPDIR" 2> /dev/null
    done < "$BACKUPFILE"
}

function main()
{
    createBackupDir
    if [ -f "$BACKUPFILE" ]; then
	backupItens
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
