#!/bin/bash

config_file=".gdb-kernel.config"


if [ ! -e $config_file ]; then
	echo "Config File Not Found"
	exit
fi

while read line
do
	section_key=$(echo ${line%=*} | sed 's/ //g')
	section_value=$(echo ${line#*=} | sed 's/ //g' | sed 's/"//g')
	case $section_key in
		"kernel_base")
			if [[ $section_value = "DEFAULT" ]]; then
				kernel_base=0xffffffff81000000
			else
				kernel_base=$section_value
			fi
		;;
		"kmod_base")
			if [[ $section_value = "DEFAULT" ]]; then
				kmod_base=0xffffffffc0000000
			else
				kmod_base=$section_value
			fi
		;;
		"kmod_name")
			kmod_name=$section_value
		;;
		"breakpoint")
			breakpoint=$section_value
		;;
		"")
		;;
		*)
			echo "Key "$section_key" Error"
		;;
	esac
	
done < $config_file

if [ $kernel_base ]; then
	gdb_kernel_base_command="add-symbol-file vmlinux "$kernel_base
fi

if [ $kmod_base ] && [ $kmod_name ]; then
	gdb_kmod_base_command="add-symbol-file "$kmod_name" "$kmod_base
fi

if [ -e ".tmp_script.gdb" ]; then
	touch .tmp_script.gdb
fi

echo -n >.tmp_script.gdb
echo $gdb_kernel_base_command >>.tmp_script.gdb
echo $gdb_kmod_base_command >>.tmp_script.gdb
echo "target remote 127.0.0.1:1234" >>.tmp_script.gdb

if [ $breakpoint ]; then
	echo "b *"$breakpoint >>.tmp_script.gdb
	echo "c" >>.tmp_script.gdb
fi

gdb-multiarch \
	-ex "source .tmp_script.gdb"
