#!/bin/bash


GIT="https://raw.githubusercontent.com/walchko/ultron/master/proxmox"

ESC="\033"
RED="$ESC[31m"
GREEN="$ESC[32m"
YELLOW="$ESC[93m"
BLUE="$ESC[34m"
MAGENTA="$ESC[35m"
CYAN="$ESC[36m"
RESET="$ESC[0m"

status () {
    echo -e "$1 $2 ${RESET}"
}

append () {
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

check_linux () {
    if [ `uname` != "Linux" ]; then exit 1; fi
}

check_root () {
    if [ "${USER}" != "root" ]; then
        status $RED "ERROR: Please run as root"
        exit 1
    fi
}
