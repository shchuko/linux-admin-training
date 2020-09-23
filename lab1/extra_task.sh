#!/bin/bash

# Find all symbolic links which point to not existing file 
# First arg - root directory to start a serach

if [[ $# < 1 ]]; then
	echo "Wrong args. Expected path as arg1"
	exit 1
fi

SEARCH_ROOT="$1"

for SYMLINK in $(find "$SEARCH_ROOT" -type l); do
	SYMLINK_TARGET=$(readlink "$SYMLINK")
	if [[ ! -f "$SYMLINK_TARGET" ]]; then
		echo "Target file $SYMLINK_TARGET not exists"
	fi
done


