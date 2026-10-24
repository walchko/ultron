#!/bin/bash
# MIT License Kevin Walchko (c) 2024


ESC="\033"
RED="$ESC[31m"
GREEN="$ESC[32m"
YELLOW="$ESC[93m"
BLUE="$ESC[34m"
MAGENTA="$ESC[35m"
CYAN="$ESC[36m"
RESET="$ESC[0m" # really 39, but don't I always want reset_all?
RESET_ALL="$ESC[0m"
SAVE_PWD=""
DOTFILESDIR=~/github/dotfiles
HOSTNAME=`uname -n`

# printing a colored status line
# status <color> <message>
status () {
    if [ $# -ne 2 ]; then
        echo -e "${RED}*** ERROR: status <color> <message> ***${RESET}"
        exit 1
    fi
    echo -e "$1$2 ${RESET_ALL}"
}

# this searches the file for the line and if it is not
# present, then it will append the line to the end of the
# file.
append () {
    if [ $# -ne 2 ]; then
        echo -e "${RED}*** ERROR: append <line> <file> ***${RESET}"
        exit 1
    fi

    line=$1
    file=$2

    grep -Fxq "$line" $file
    ret_code=$? # capture return code
    if [ "$ret_code" == "0" ]; then
        status $CYAN "ALREADY Done: ${line} >> ${file}"
    else
        echo "${line}" | tee -a $file > /dev/null
        status $GREEN "UPDATED ${file} with ${line}"
    fi
}

# this will fail if the OS is not linux
fail_not_linux () {
    if [ `uname` != "Linux" ]; then
        status $RED "*** ERROR: OS is not Linux ***"
        exit 1
    fi
}

# this will fail if the user ID is not 0 (root)
fail_not_root () {
    if [ `id -u` != "0" ]; then
        # echo -e "${RED}*** ERROR: User is not ROOT ***${RESET}"
        status $RED "*** ERROR: User is not ROOT ***"
        exit 1
    fi
}

print_done () {
    status $GREEN "***************"
    status $GREEN "*             *"
    status $GREEN "*   SUCCESS   *"
    status $GREEN "*             *"
    status $GREEN "***************"
}

# push_dir() {
#     SAVE_PWD=`pwd`
# }

# pop_dir() {
#     cd $SAVE_PWD
#     SAVE_PWD=""
# }

# debian - MOTD
linux_motd() {
    status $GREEN " - setup motd"
    apt install -y lsb-release figlet avahi-daemon
    rm -f /etc/motd            # remove existing one
    touch /etc/motd            # create empty file
    chmod 644 /etc/motd        # set permissions
    chown root:root /etc/motd  # set ownership

    rm -f /etc/update-motd.d/* # remove all motd
    # ln -s ~/github/dotfiles/proxmox/01-custom /etc/update-motd.d/01-custom
    cat << 'EOF' > /etc/update-motd.d/01-custom
#!/bin/bash

# blank screen =====================
echo -e "\e[2J\e[;H"

# set colors =======================
BW="\e[1;99m"
W="\e[0;39m"
R="\e[0;31m"
G="\e[0;32m"
RESET="\e[0m"

# get info =========================
UPTIME=`uptime -p | cut -d " " -f2-`

SWAP=`free -h | grep "Swap" | awk '{print $2}'`
SWAP_FREE=`free -h | grep "Swap" | awk '{print $4}'`

MEM=`free -h | grep "Mem" | awk '{print $2}'`
MEM_FREE=`free -h | grep "Mem" | awk '{print $4}'`

#IPLAN=`ip -4 -o addr list eth0 | awk '{print $4}' | cut -d/ -f1`
IPLAN=`hostname -I`

DF=`df -Th | grep /dev/loop | awk '{print $3 }'`
DF_FREE=`df -Th | grep /dev/loop | awk '{print $5 }'`
DF_PER=`df -Th | grep /dev/loop | awk '{print $6 }'`
DF_TYPE=`df -Th | grep /dev/loop | awk '{print $2 }'`
# DDF=""
# while read -r line; do
#   DDF+="Storage............: ${W}${line}${R}"
# done

CPUTEMP=$((`cat /sys/class/thermal/thermal_zone0/temp`/1000*9/5+32))

PROCS=`ps ax | wc -l | tr -d " "`

# get the load averages
read one five fifteen rest < /proc/loadavg

echo -e "${BW}"
figlet `uname -n`
echo -e "${RESET}"

echo -e "${G}
`date +"%A, %e %B %Y, %r"`
`uname -srmo`
`lsb_release -d 2>/dev/null`
`lsb_release -c 2>/dev/null`
${R}
Uptime.............: ${W}${UPTIME}${R}
Memory.............: ${W}${MEM_FREE} (Free) / ${MEM} (Total)${R}
Swap...............: ${W}${SWAP_FREE} (Free) / ${SWAP} (Total)${R}
Storage............: ${W}${DF_FREE}B (Free) / ${DF}B (Total)${R}
Storage Used.......: ${W}${DF_PER} ${DF_TYPE}${R}
Load Averages......: ${W}${one}, ${five}, ${fifteen} (1, 5, 15 min)${R}
CPU Temperature....: ${W}${CPUTEMP} F${R}
Running Processes..: ${W}${PROCS}${R}
IP Addr............: ${W}${IPLAN}${W}
${RESET}"
EOF
    chmod 744 /etc/update-motd.d/01-custom        # set permissions
    chown root:root /etc/update-motd.d/01-custom  # set ownership
}

# setup ssh
# This can be run multiple times, no side effects
linux_ssh() {
    status $GREEN " - ssh: setting up authorized keys"
    mkdir -p ${HOME}/.ssh 
    rm -f ${HOME}/.ssh/authorized_keys
    cat << EOF > ${HOME}/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCJuBFkift9eHbOTgDDcT66DmMcCoSeOQXdw4xcSdbw kevin@Zapp.local
EOF
}

# SMB --------------------------------
linux_smb() {
    status $YELLOW "Samba Install"
    apt install samba samba-common samba-common-bin cifs-utils python3-pexpect -y

    grep -Fxq "[nfs]" /etc/samba/smb.conf
    ret_code=$?
    if [ "$ret_code" == "0" ]; then
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
[${HOSTNAME}]
   read only = no
   path = /${USER}
   guest ok = yes
EOF
fi

    service smbd restart
    service nmbd restart
}

# Use git to get command line preferences
# get_dot_files() {
#     push_dir
#     mkdir -p ${HOME}/github
#     cd ${HOME}/github
#     # echo `pwd`
#     git clone https://github.com/walchko/dotfiles.git
#     cd ${HOME}

#     mv ${HOME}/.bashrc ${HOME}/.bashrc.old
#     ln -s ${HOME}/github/dotfiles/proxmox/bashrc ${HOME}/.bashrc
#     pop_dir

#     # linux_motd
#     # linux_ssh
# }

# Set command line
set_dot_files() {
    echo " - setup dot files"
    # Install packages
    # original PS1=${debian_chroot:+($debian_chroot)}\u@\h:\w\$
    # PKGS="avahi-daemon tree"
    if [ `id -u` == "0" ]]; then
        # red theme
        CB="\033[1;91m"
        C="\033[0;31m"

        # apt install $PKGS -y
    else
        # blue theme
        CB="\033[1;94m"
        C="\033[0;34m"

        # sudo apt install $PKGS -y
    fi
    append "export PS1='${debian_chroot:+($debian_chroot)}${CB}\u@\h:${C}\w\$ \033[0m'" ${HOME}/.bashrc
    append 'export EDITOR=nano' ${HOME}/.bashrc
    append 'export LANG=en_US.UTF-8' ${HOME}/.bashrc
    append 'alias ls="ls --color -h"' ${HOME}/.bashrc
    append 'alias systemctl="systemctl --no-pager"' ${HOME}/.bashrc
    append 'alias systemctl-running="systemctl list-units --type=service --state=running"' ${HOME}/.bashrc
    append 'alias df="df -Th"' ${HOME}/.bashrc
    status $YELLOW "==> Updated ${HOME}/.bashrc"
}

linux_get_basics() {
    status $GREEN " - update / upgrade / autoremove"
    apt update && apt upgrade -y && apt autoremove

    status $GREEN " - locales"
    apt install -y locales
    locale-gen en_US en_US.UTF-8
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8

    status $GREEN " - timezone"
    timedatectl set-timezone America/New_York

    status $GREEN " - curl"
    apt install -y curl
}

# get C dev tools
linux_get_devtools() {
    status $GREEN " - install clang / git / tree / htop / cmake"
    apt install -y git htop tree clang clang-format cmake
}

# setup python and create virtual environment
linux_get_python() {
    status $GREEN " - python"
    if [[ -d ${HOME}/venvs ]]; then
        status $CYAN "Python already setup"
        return
    fi

    apt install -y python3-venv
    mkdir -p ${HOME}/venvs
    cd ${HOME}/venvs
    python3 -m venv ${HOME}/venvs/py
    . ${HOME}/venvs/py/bin/activate
    pip install -U pip setuptools
}

# case "$(uname -s)" in
#     Darwin) os="macos" ;;
#     Linux)  os="linux" ;;
#     *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
# esac

# case "$(uname -m)" in
#     x86_64|amd64|AMD64) arch="x86_64" ;;
#     arm64|aarch64|ARM64) arch="aarch64" ;;
#     *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
# esac

cat << "EOF"
 ____       _     _               _    __  ______   ____       _               
|  _ \  ___| |__ (_) __ _ _ __   | |   \ \/ / ___| / ___|  ___| |_ _   _ _ __  
| | | |/ _ \ '_ \| |/ _` | '_ \  | |    \  / |     \___ \ / _ \ __| | | | '_ \ 
| |_| |  __/ |_) | | (_| | | | | | |___ /  \ |___   ___) |  __/ |_| |_| | |_) |
|____/ \___|_.__/|_|\__,_|_| |_| |_____/_/\_\____| |____/ \___|\__|\__,_| .__/ 
                                                                        |_|    
EOF

fail_not_linux
fail_not_root

uname -a


# if [[ "${os}" == "macos" ]]; then
#     status $RED "Not linux, is ${os}"
#     exit 1
# fi

status $GREEN "Tasks:"
linux_get_basics
# get_dot_files
set_dot_files
linux_motd
linux_ssh
# linux_get_devtools
linux_get_python
print_done
