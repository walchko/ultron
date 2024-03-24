#!/bin/bash
# MIT License Kevin Walchko (c) 2024
#
# Setups up basic user enviornment

source <(curl -s https://raw.githubusercontent.com/walchko/ultron/master/proxmox/source_me.sh)

# Install packages
# original PS1=${debian_chroot:+($debian_chroot)}\u@\h:\w\$
PKGS="avahi-daemon tree"
if [ `id -u` == "0" ]]; then
    # red theme
    CB="\033[1;91m"
    C="\033[0;31m"

    apt install $PKGS -y
else
    # blue theme
    CB="\033[1;94m"
    C="\033[0;34m"

    sudo apt install $PKGS -y
fi

# Fix command line
append "export PS1='${debian_chroot:+($debian_chroot)}${CB}\u@\h:${C}\w\$ \033[0m'" ~/.bashrc
append 'export EDITOR=nano' ~/.bashrc
append 'alias ls="ls --color -h"' ~/.bashrc
append 'alias systemctl="systemctl --no-pager"' ~/.bashrc
append 'alias systemctl-running="systemctl list-units --type=service --state=running"' ~/.bashrc
append 'alias df="df -Th"' ~/.bashrc
status $YELLOW "==> Updated ~/.bashrc"
