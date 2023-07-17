#!/bin/bash

if [ -f Makefile ];then
	make
	cp main ./rootfs
fi

for file in `ls `
do
	if [[ $file =~ \.sh$ ]];then
		boot_script=$file
		break
	fi
done

cd ./rootfs

find . | cpio -H newc -o --owner root:root > ../rootfs.cpio

cd ..

./$boot_script
