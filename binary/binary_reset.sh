#!/bin/bash

set -e

if [ -e exp.py ]; then
	echo "Exp File Has Existed"
	exit
fi

if [ ! -e main ]; then
	echo "Main File Not Found"
	exit
elif [ ! -x main ]; then
	chmod a+x main
fi

file_info=$(file main)

if [[ $file_info =~ "x86-64" ]]; then
	arch="x86-64"
elif [[ $file_info =~ "Intel 80386" ]]; then
	arch="x86"
elif [[ $file_info =~ "ARM" ]] && [[ $file_info =~ "32-bit" ]]; then
	arch="Arm"
elif [[ $file_info =~ "ARM" ]] && [[ $file_info =~ "64-bit" ]]; then
	arch="aarch64"
else
	arch="unknown"
fi

case $arch in
	"x86")
	;&
	"x86-64")
		touch exp.py
		echo "from pwn import*" >>exp.py
		echo "r=process('./main')" >>exp.py
		echo -e "context.log_level='debug'\n\n\n" >>exp.py
		echo "r.interactive()" >>exp.py
	;;
	"Arm")
		touch exp.py
		echo "from pwn import*" >>exp.py
		echo "#r=process(['qemu-arm','-g','1234','-L','/usr/arm-linux-gnueabi/','./main'])" >>exp.py
		echo "r=process(['qemu-arm','-L','/usr/arm-linux-gnueabi/','./main'])" >>exp.py
		echo -e "context(os='linux',arch='arm',log_level='debug')\n\n\n" >>exp.py
		echo "r.interactive()" >>exp.py
	;;
	"aarch64")
		touch exp.py
		echo "from pwn import*" >>exp.py
		echo "#r=process(['qemu-aarch64','-g','1234','-L','/usr/aarch64-linux-gnu/','./main'])" >>exp.py
		echo "r=process(['qemu-aarch64','-L','/usr/aarch64-linux-gnu/','./main'])" >>exp.py
		echo -e "context(os='linux',arch='aarch64',log_level='debug')\n\n\n" >>exp.py
		echo "r.interactive()" >>exp.py
	;;
	*)
		echo "Unknown Error Occurred"
	;;
esac

echo "Binary "${arch}" File Set Success"
