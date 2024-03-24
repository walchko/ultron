#!/bin/bash

GIT="https://raw.githubusercontent.com/walchko/ultron/master/proxmox"

ESC="\033"
RED="$ESC[31m"
GREEN="$ESC[32m"
YELLOW="$ESC[93m"
MAGENTA="$ESC[35m"
CYAN="$ESC[36m"
RESET="$ESC[39m"

status () {
    echo -e "$1 $2 ${RESET}"
}

# check if we are root
if [[ "${EUID}" != "0" || "${USER}" != "root" ]]; then
    status $RED "ERROR: Please run as root"
    exit 1
fi

# Check args
# if [[ $# -eq 1 ]]; then
#     PASSWD=$1
# else
#     status $RED "ERROR: script.sh <password>"
#     exit 1
# fi

# append () {
#     line=$1
#     file=$2

#     grep -Fxq "$line" $file
#     ret_code=$? # capture return code
#     if [[ "$ret_code" == "0" ]]; then
#         echo -e "${CYAN}ALREADY Done: ${line} >> ${file}${RESET}"
#     else
#         echo "${line}" | tee -a $file > /dev/null
#         echo -e "${GREEN}UPDATED ${file} with ${line}${RESET}"
#     fi
# }

# echo "Setup Proxmox"
cat << "EOF"
 ____       _                 ____
/ ___|  ___| |_ _   _ _ __   |  _ \ _ __ _____  ___ __ ___   _____  __
\___ \ / _ \ __| | | | '_ \  | |_) | '__/ _ \ \/ / '_ ` _ \ / _ \ \/ /
 ___) |  __/ |_| |_| | |_) | |  __/| | | (_) >  <| | | | | | (_) >  <
|____/ \___|\__|\__,_| .__/  |_|   |_|  \___/_/\_\_| |_| |_|\___/_/\_\

EOF

# Fix repos
mkdir -p /root/sources
if [[ -f "/etc/apt/sources.list.d/ceph.list" ]]; then
    mv /etc/apt/sources.list.d/ceph.list /root/sources
    status $GREEN "++ Removed ceph.list"
fi
if [[ -f "/etc/apt/sources.list.d/pve-enterprise.list" ]]; then
    mv /etc/apt/sources.list.d/pve-enterprise.list /root/sources
    REPO="deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription"
    echo "${REPO}" > /etc/apt/sources.list.d/pve-no-subscription.list
    status $GREEN "++ Removed pve-enterprise.list"
fi
status $YELLOW "==> Updated Proxmox Repos"

# install packages
apt update && apt upgrade -y
apt install avahi-daemon lm-sensors duf tree htop
status $YELLOW "==> Updated and installed software"

# # Fix command line
# append 'alias ls="ls --color -h"' ~/.bashrc
# append 'alias systemctl="systemctl --no-pager"' ~/.bashrc
# append 'alias systemctl-running="systemctl list-units --type=service --state=running"' ~/.bashrc
# append 'alias df="df -Th"' ~/.bashrc
# status $YELLOW "==> Updated ~/.bashrc"
curl -sSL "${GIT}/env.sh" | bash



status $GREEN "***************"
status $GREEN "*             *"
status $GREEN "*   SUCCESS   *"
status $GREEN "*             *"
status $GREEN "***************"
