__pwn-envset()
{
	COMPREPLY=()
	local cur=${COMP_WORDS[COMP_CWORD]};
	local cmd=${COMP_WORDS[COMP_CWORD-1]};
	local pre=${COMP_WORDS[COMP_CWORD-2]};
	
	if [[ $cmd == "pwn-envset" ]]; then
		cmdlist="-k --kernel -b --binary"
	else
		case $cmd in
			"-k")
			;&
			"--kernel")
				cmdlist="init clean"
			;;
			"-b")
			;&
			"--binary")
				cmdlist="init clean set-libc judge-libc"
			;;
		esac
		
		case $pre in 
			"-k")
			;&
			"--kernel")
				case $cmd in
					"init")
						cmdlist=$(ls)
					;;
				esac
			;;
			"-b")
			;&
			"--binary")
				case $cmd in
					"init")
					;&
					"set-libc")
					;&
					"judge-libc")
						cmdlist=$(ls)
					;;
				esac
			;;
		esac
		
	fi
	
	local wordlist="$(compgen -W "${cmdlist}" -- $cur)"
	COMPREPLY=(${wordlist})
}

complete -F __pwn-envset pwn-envset 
