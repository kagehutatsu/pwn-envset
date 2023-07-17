#!/bin/bash

script_file="gdb.script"


if [ ! -e $script_file ]; then
	echo "Script File Not Found"
	exit
fi

gdb-multiarch \
	-ex "source "$script_file
