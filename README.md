# pwn-envset

A small tools for pwn

Easy to use and easy to understand

```
[install]
sudo ./install.sh

[usage]
pwn-envset
  -b
  --binary   For common pwn, including multi-arch pwn such as Arm, aarch, mips,
             and the most common x86 and x86-64 pwn
            
  -k
  --kernel   For kernel pwn (with gdb script)

gdb-kernel   gdb-multiarch start within configs in ./.gdb-kernel.config
             such as making breakpoints
                     set kernel_base and kmod_base
                     automatic target remote localhost:1234

[key]
reset        Making some preparation for Pwn exploit
clean        Cleaning up something useless like gdb_history and DS_store etc.
libc         Change ELF shared library link

[example]
pwn-envset --binary reset

pwn-envset --kernel clean
```

key "libc" is based on my another repositories https://github.com/kagehutatsu/set-libc

It's never finished, and I will edit it for a long time
