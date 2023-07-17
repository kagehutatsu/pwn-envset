#!/bin/bash

global_libc_path=~/Programs/glibc-all-in-one/libs/
local_libc_path=$1

if [[ ! -e $1 ]]; then
	echo "Libc File Not Found"
	exit
fi

for file in $(ls $global_libc_path)
do
	if [[ -d $global_libc_path$file ]]; then
		result=$(diff $1 $global_libc_path$file/libc.so.6)
		if [[ -z $result ]]; then
			echo $file
			exit
		fi
	fi
done

echo "Same Libc Not Found"
