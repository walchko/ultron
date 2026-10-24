#!/bin/bash
# MIT License Kevin Walchko (c) 2024


source <(curl -s https://raw.githubusercontent.com/walchko/ultron/master/proxmox/source_me.sh)

fail_not_linux
fail_not_root

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

# Fix command line
curl -sSL "${GIT}/env.sh" | /bin/bash

print_done
