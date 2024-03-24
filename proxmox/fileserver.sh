#!/bin/bash
# MIT License Kevin Walchko (c) 2024

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
    status $RED "Please run as root"
    exit 1
fi

append () {
    line=$1
    file=$2

    grep -Fxq "$line" $file
    ret_code=$? # capture return code
    if [[ "$ret_code" == "0" ]]; then
        echo -e "${CYAN}ALREADY Done: ${line} >> ${file}${RESET}"
    else
        echo "${line}" | tee -a $file > /dev/null
        echo -e "${GREEN}UPDATED ${file} with ${line}${RESET}"
    fi
}

cat << "EOF"
 _____ _ _        ____                             ___           _        _ _
|  ___(_) | ___  / ___|  ___ _ ____   _____ _ __  |_ _|_ __  ___| |_ __ _| | |
| |_  | | |/ _ \ \___ \ / _ \ '__\ \ / / _ \ '__|  | || '_ \/ __| __/ _` | | |
|  _| | | |  __/  ___) |  __/ |   \ V /  __/ |     | || | | \__ \ || (_| | | |
|_|   |_|_|\___| |____/ \___|_|    \_/ \___|_|    |___|_| |_|___/\__\__,_|_|_|

EOF

# Update / Upgrage -------------------
apt update && apt upgrade -y

# NFS --------------------------------
status $YELLOW "NFS Install"
apt install nfs-kernel-server -y
systemctl start nfs-kernel-server
systemctl enable nfs-kernel-server

mkdir /mnt/nfs -p
chown nobody:nogroup -R /mnt/nfs
chmod 755 /mnt/nfs

# echo "/mnt/nfs 10.0.1.0/24(rw,sync,no_subtree_check)" >> /etc/exports
append "/mnt/nfs 10.0.1.0/24(rw,sync,no_subtree_check)" /etc/exports
exportfs -a
systemctl restart nfs-kernel-server

# SMB --------------------------------
status $YELLOW "Samba Install"
apt install samba samba-common samba-common-bin cifs-utils python3-pexpect -y

grep -Fxq "[nfs]" /etc/samba/smb.conf
ret_code=$?
if [[ "$ret_code" == "0" ]]; then
    status $CYAN "smb.conf already setup for /mnt/nfs"
else
    mv /etc/samba/smb.conf /etc/samba/smb.conf.bak

    cat << EOF > /etc/samba/smb.conf
[global]
   workgroup = WORKGROUP
   wins support = yes
   dns proxy = no

#### Debugging/Accounting ####
   log file = /var/log/samba/log.%m
   max log size = 1000
   syslog = 0
   panic action = /usr/share/samba/panic-action %d

####### Authentication #######
   server role = standalone server
   passdb backend = tdbsam
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   map to guest = bad user

############ Misc ############
# Allow users who've been granted usershare privileges to create
# public shares, not just authenticated ones
   usershare allow guests = yes

#======================= Share Definitions =======================
[nfs]
   read only = no
   path = /mnt/nfs
   guest ok = yes
EOF
fi

service smbd restart
service nmbd restart

# NFS
NFS_VERS=`cat /proc/fs/nfsd/versions`
status $CYAN "NFS versions: ${NFS_VERS}"