#!/bin/bash

libc_path=~/Program/glibc-all-in-one/libs/
binary_path=$(pwd)

get_libc_list()
{
	libc_num=0

	for file in $(ls $libc_path)
	do
		if [[ -d $libc_path$file ]]; then
			libc_name_noarch=${file%_*}
			for libc_name in ${libc_list[@]}
			do
				if [[ $libc_name = $libc_name_noarch ]]; then
					libc_name_noarch=""
					break
				fi
			done
			if [[ $libc_name_noarch != "" ]]; then
				libc_list[$libc_num]=$libc_name_noarch
				let libc_num++
			fi
		fi
	done
}

get_binary_arch()
{
	file_info=$(file ${binary_path}/main)	

	if [[ $file_info =~ "x86-64" ]]; then
		arch="amd64"
	elif [[ $file_info =~ "Intel 80386" ]]; then
		arch="i386"
	else
		echo Unknown Arch, Unable to patch
		exit
	fi
}

get_current_binary_libc()
{
	current_binary_libc_info=$(readelf -d $binary_path/main)
	current_binary_libc=${current_binary_libc_info%libc.so.6*}
	current_binary_libc=${current_binary_libc##*[}
	current_binary_libc=${current_binary_libc}libc.so.6
	
	current_binary_ld_info=$(readelf -l $binary_path/main)
	current_binary_ld=${current_binary_ld_info%ld-linux-x86-64.so.2*}
	current_binary_ld=${current_binary_ld#*/}
	current_binary_ld=/${current_binary_ld}ld-linux-x86-64.so.2
}

get_user_libc_mode()
{
	echo "which mode would you choose?"
	echo "1.local-mode"
	echo "2.global-mode"
	echo -e "choice: \c"
	
	read -a user_raw_libc_mode
	
	if [[ $user_raw_libc_mode = 1 ]]; then
		user_libc_mode=local-mode
	elif [[ $user_raw_libc_mode = 2 ]]; then
		user_libc_mode=global-mode
	fi
}

get_user_libc_version_choice()
{
	for (( i = 0; i < $libc_num; i++ )); do
		echo $((i+1))": "${libc_list[i]}
	done
	echo -e "choice: \c"
	read -a user_raw_libc_version_choice
	
	user_libc_version_choice=$((user_raw_libc_version_choice-1))
}

create_patchelf_command()
{
	if [[ $user_libc_mode = local-mode ]]; then
		patch_libc_cmd="patchelf --replace-needed "${current_binary_libc}" "$binary_path"/libc-"${libc_list[user_libc_version_choice]%-*}".so main"
	elif [[ $user_libc_mode = global-mode ]]; then
		patch_libc_cmd="patchelf --replace-needed "${current_binary_libc}" "$libc_path${libc_list[user_libc_version_choice]}"_"$arch"/libc.so.6 main"
	fi
	
	patch_ld_cmd="patchelf --set-interpreter  "$libc_path${libc_list[user_libc_version_choice]}"_"$arch"/ld-linux-x86-64.so.2 main"
}

exec_patchelf()
{
	$patch_libc_cmd
	$patch_ld_cmd
}

get_libc_list

get_binary_arch

get_current_binary_libc

get_user_libc_mode

get_user_libc_version_choice

create_patchelf_command

exec_patchelf

