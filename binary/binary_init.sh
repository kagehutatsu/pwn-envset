#!/bin/bash

binary_file=$1

if [ -e exp.py ]; then
	echo "Exp File Has Existed"
	exit
fi

if [ ! -e $binary_file ]; then
	echo "Binary File Not Found"
	exit
elif [ ! -x $binary_file ]; then
	chmod a+x $binary_file
fi

file_info=$(file $binary_file)

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
		echo "r=process('./$binary_file')" >>exp.py
		echo -e "context.log_level='debug'\n\n\n" >>exp.py
		echo "r.interactive()" >>exp.py
	;;
	"Arm")
		touch exp.py
		echo "from pwn import*" >>exp.py
		echo "#r=process(['qemu-arm','-g','1234','-L','/usr/arm-linux-gnueabi/','./$binary_file'])" >>exp.py
		echo "r=process(['qemu-arm','-L','/usr/arm-linux-gnueabi/','./$binary_file'])" >>exp.py
		echo -e "context(os='linux',arch='arm',log_level='debug')\n\n\n" >>exp.py
		echo "r.interactive()" >>exp.py
	;;
	"aarch64")
		touch exp.py
		echo "from pwn import*" >>exp.py
		echo "#r=process(['qemu-aarch64','-g','1234','-L','/usr/aarch64-linux-gnu/','./$binary_file'])" >>exp.py
		echo "r=process(['qemu-aarch64','-L','/usr/aarch64-linux-gnu/','./$binary_file'])" >>exp.py
		echo -e "context(os='linux',arch='aarch64',log_level='debug')\n\n\n" >>exp.py
		echo "r.interactive()" >>exp.py
	;;
	*)
		echo "Unknown Error Occurred"
	;;
esac

echo "Binary "${arch}" File Set Success"
