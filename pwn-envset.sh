#!/bin/bash

set -e
shell_path=$(realpath $0)
base_path=${shell_path%/*}

function binary_envset()
{
	case $1 in
		"reset")
			exec ${base_path}/binary/binary_reset.sh $2
		;;
		"set-libc")
			exec ${base_path}/binary/set-libc.sh $2
		;;
		"judge-libc")
			exec ${base_path}/binary/judge-libc.sh $2
		;;
		"clean")
			exec ${base_path}/binary/binary_clean.sh
		;;
		*)
			echo "Key "$1" Error"
		;;
	esac
}

function kernel_envset()
{
	case $1 in
		"reset")
			exec ${base_path}/kernel/kernel_reset.sh
		;;
		"clean")
			exec ${base_path}/kernel/kernel_clean.sh
		;;
		*)
			echo "Key "$1" Error"
		;;
	esac
}

case $1 in
	"-b")
	;&
	"--binary")
		binary_envset $2 $3
	;;
	"-k")
	;&
	"--kernel")
		kernel_envset $2 $3
	;;
	*)
		echo "Argument "$1" Error"
	;;
esac
