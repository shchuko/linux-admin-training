#!/bin/bash

# Find all symbolic links which point to not existing file 
# First arg - root directory to start a serach

if [[ $# < 1 ]]; then
	echo "Wrong args. Expected path as arg1"
	exit 1
fi

SEARCH_ROOT="$1"

find "$SEARCH_ROOT" -xtype l

