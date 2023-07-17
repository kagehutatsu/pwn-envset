#!/bin/bash

function analyse_argv()
{
	argv=`getopt -o m:s: -- "$@"`

	eval set -- "${argv}"

	while [ -n "$1" ]
	do
		case $1 in
			-m)
				if [ -f Makefile ];then
					make
					cp main ./rootfs
				fi
				shift
			;;
			-s)
				exec $2
				shift
			;;
			--)
				shift
				break
			;;
			*)
				echo "Invalid option $1"
				exit
			;;
		esac
		shift
	done
}

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
