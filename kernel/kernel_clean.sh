#!/bin/bash

rm -f .gdb-kernel.config
rm -f .tmp_script.gdb
rm -f .gdb_history
rm -f ./*.ko

for file in $(ls ./)
do
	if [ "${file##*.}" = "cpio" ] || [ "${file##*.}" = "img" ]; then
		archive_fileheader="${file%%.*}"
		archive_filename=$file
	fi
done

rm $archive_filename
mv ./.archive_backup $archive_filename

rm -rf $archive_fileheader
