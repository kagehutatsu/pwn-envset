#!/bin/bash

base_path=$(cd `dirname $0`; pwd)

sudo ln -s $base_path/pwn-envset.sh /usr/bin/pwn-envset
sudo ln -s $base_path/kernel/gdb-kernel.sh /usr/bin/gdb-kernel

sudo cp $base_path/pwn-envset_competition.sh /etc/bash_completion.d
echo "source /etc/bash_completion.d/pwn-envset_competition.sh" >> /etc/bash.bashrc
