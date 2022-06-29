#!/bin/bash

shell_path=$(realpath $0)
base_path=${shell_path%/*}

pwd=$(pwd)

for file in $(ls ./)
do
	if [ "${file##*.}" = "ko" ]; then
		kmod_name=$file
	elif [ "${file##*.}" = "cpio" ] || [ "${file##*.}" = "img" ]; then
		archive_fileheader="${file%%.*}"
		archive_filename=$file
	fi
done

if [ ! $archive_fileheader ]; then
	echo "File system archive Not Found"
	exit
fi

if [ ! -d $archive_fileheader ]; then
	file_info=$(file $archive_filename)
	if [[ $file_info =~ "gzip" ]]; then
		mv ${archive_filename} ${archive_filename}.gz
		gzip -d ${archive_filename}.gz
	fi
	mkdir $archive_fileheader
	cd ./$archive_fileheader
	cpio -idm < ../$archive_filename
fi

cp $base_path/kernel/reset-file/gdb.script ./

cp $base_path/kernel/reset-file/gdb.script ./
