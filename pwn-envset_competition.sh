__pwn-envset()
{
	COMPREPLY=()
	local cur=${COMP_WORDS[COMP_CWORD]};
	local cmd=${COMP_WORDS[COMP_CWORD-1]};
	case $cmd in
		"pwn-envset")
			cmdlist="-k --kernel -b --binary"
		;;
		"-k")
		;&
		"--kernel")
			cmdlist="reset clean"
		;;
		"-b")
		;&
		"--binary")
			cmdlist="reset clean libc"
		;;
	esac
	local wordlist="$(compgen -W "${cmdlist}" -- $cur)"
	COMPREPLY=(${wordlist})
}
complete -F  __pwn-envset pwn-envset
