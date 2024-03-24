#!/bin/bash
# MIT License Kevin Walchko (c) 2024
# script.sh <nfs_share>
# nfs_share ex: 1.2.3.4:/folder

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

append () {
    line=$1
    file=$2

    grep -Fxq "$line" $file
    ret_code=$? # capture return code
    if [[ "$ret_code" == "0" ]]; then
        status $CYAN "ALREADY Done: ${line} >> ${file}"
    else
        echo "${line}" | tee -a $file > /dev/null
        status $GREEN "UPDATED ${file} with ${line}"
    fi
}

# check if we are root
if [[ "${EUID}" != "0" || "${USER}" != "root" ]]; then
    status $RED "ERROR: Please run as root"
    exit 1
fi

if [[ $# -eq 1 ]]; then
    NFS_SHARE=$1
else
    status $RED "ERROR: script.sh <nfs_share>"
    status $RED "       nfs_share ex: 1.2.3.4:/folder"
    exit 1
fi

cat << "EOF"
 ____  _             ___           _        _ _
|  _ \| | _____  __ |_ _|_ __  ___| |_ __ _| | |
| |_) | |/ _ \ \/ /  | || '_ \/ __| __/ _` | | |
|  __/| |  __/>  <   | || | | \__ \ || (_| | | |
|_|   |_|\___/_/\_\ |___|_| |_|___/\__\__,_|_|_|

EOF

apt update && apt upgrade -y
apt install curl gnupg -y
apt install nfs-common -y

curl -sS https://downloads.plex.tv/plex-keys/PlexSign.key | gpg --dearmor | tee /usr/share/keyrings/plex.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/plex.gpg] https://downloads.plex.tv/repo/deb public main" > /etc/apt/sources.list.d/plexmediaserver.list

apt update
apt install plexmediaserver -y

mkdir -p /mnt/nfs
# chown nobody:nogroup -R /mnt/nfs

append "${NFS_SHARE} /mnt/nfs nfs defaults 0 2" /etc/fstab
mount -a

# Fix command line
curl -sSL "${GIT}/env.sh" | bash