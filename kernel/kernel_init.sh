#!/bin/bash

shell_path=$(realpath $0)
base_path=${shell_path%/*}

function analyse_argv()
{
	argv=`getopt -o i:c: -l image:,compress: -- "$@"`

	eval set -- "${argv}"

	while [ -n "$1" ]
	do
		case $1 in
			--image|-i)
				img_init $2 "img"
				shift
			;;
			--compress|-c)
				img_init $2 "compress"
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

function img_init()
{
	rootfs_file=$2
	rootfs_type=$3
	
	mkdir -p rootfs
}

analyse_argv

cp $base_path/kernel/reset-file/gdb.script ./

cp $base_path/kernel/reset-file/Makefile ./
