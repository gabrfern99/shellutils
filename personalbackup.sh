#!/bin/bash

#   A simple shell script to backup personal config files given a wordlist of them
#   Copyright (C) 2020  Gabriel Fernando
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 3 of the License, or
#   (at your option) any later version.
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software Foundation,
#   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA


BACKUPDIR="$1"
BACKUPFILE="$2"

function createBackupDir()
{
	if [ ! -d $BACKUPDIR ]; then
		echo "Creating user initial backup directory"
		mkdir $BACKUPDIR
	fi
}

function backupItens()
{
	while read itens; do
		for iten in $itens; do
			filteredItem="$(basename $iten)"
			if [[ -d $BACKUPDIR$filteredItem || -f $BACKUPDIR$filteredItem ]];
			then
				continue
			else
				rsync -avh --compress-choice=zstd --compress-level=3 $iten $BACKUPDIR 2> /dev/null
			fi
		done
	done < <(grep . $BACKUPFILE)

}

function checkChangedItens()
{
	while read itens; do
		for iten in $itens; do
			filteredItem="$(basename $iten)"
			if [[ $(diff -qr $iten $BACKUPDIR$filteredItem 2>/dev/null) ]]; then
				rsync -avh --compress-choice=zstd --compress-level=3 $iten $BACKUPDIR 2> /dev/null
			else
				continue
			fi
		done
	done < <(grep . $BACKUPFILE)
}

function main()
{
	createBackupDir
	if [ -f $BACKUPFILE ]; then
		backupItens
		checkChangedItens
	else
		echo "No file with itens to backup"
		echo "See 'personalbackup.sh --help' for more information"
	fi
}

if [ $# -gt 2 -o $# -eq 0 -o  $# -eq 1 ]; then
	echo "Usage: backupdir backupfile"
else
	main
fi
