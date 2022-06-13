#!/bin/bash

set -e

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

cp ./$archive_filename ./.archive_backup

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

if [ ! $kmod_name ]; then
	for kmod_file in $(find ./ -name "*.ko")
	do
		cp $kmod_file ../
		kmod_name=${file##*/}
		break
	done
fi

cd $pwd

touch .gdb-kernel.config
echo -e "kernel_base=\"\"" >>.gdb-kernel.config
echo -e "kmod_base=\"\"" >>.gdb-kernel.config
echo -e "kmod_name=\"${kmod_name}\"" >>.gdb-kernel.config
echo -e "breakpoint=\"\"" >>.gdb-kernel.config
