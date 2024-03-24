#!/bin/bash
# MIT License Kevin Walchko (c) 2024
#
# Setups up basic user enviornment

source <(curl -s https://raw.githubusercontent.com/walchko/ultron/master/proxmox/source_me.sh)

# ESC="\033"
# RED="$ESC[31m"
# GREEN="$ESC[32m"
# YELLOW="$ESC[93m"
# BLUE="$ESC[34m"
# MAGENTA="$ESC[35m"
# CYAN="$ESC[36m"
# RESET="$ESC[39m"

# status () {
#     echo -e "$1 $2 ${RESET}"
# }

# append () {
#     line=$1
#     file=$2

#     grep -Fxq "$line" $file
#     ret_code=$? # capture return code
#     if [[ "$ret_code" == "0" ]]; then
#         status $CYAN "ALREADY Done: ${line} >> ${file}"
#     else
#         echo "${line}" | tee -a $file > /dev/null
#         status $GREEN "UPDATED ${file} with ${line}"
#     fi
# }

# Install packages
# original PS1=${debian_chroot:+($debian_chroot)}\u@\h:\w\$
PKGS="avahi-daemon tree"
if [[ "${EUID}" == "0" || "${USER}" == "root" ]]; then
    # red
    CB="\033[1;91m"
    C="\033[0;31m"
    # append "export PS1='${CB}\u@\h:${C}\w\$ \033[0m'" ~/.bashrc

    apt install $PKGS
else
    # blue
    CB="\033[1;94m"
    C="\033[0;34m"

    sudo apt install $PKGS
fi

# Fix command line
append "export PS1='${CB}\u@\h:${C}\w\$ \033[0m'" ~/.bashrc
append 'alias ls="ls --color -h"' ~/.bashrc
append 'alias systemctl="systemctl --no-pager"' ~/.bashrc
append 'alias systemctl-running="systemctl list-units --type=service --state=running"' ~/.bashrc
append 'alias df="df -Th"' ~/.bashrc
append 'export EDITOR=nano'
status $YELLOW "==> Updated ~/.bashrc"