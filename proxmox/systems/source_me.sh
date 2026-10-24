#!/bin/bash
# MIT License Kevin Walchko (c) 2024


GIT="https://raw.githubusercontent.com/walchko/ultron/master/proxmox"

ESC="\033"
RED="$ESC[31m"
GREEN="$ESC[32m"
YELLOW="$ESC[93m"
BLUE="$ESC[34m"
MAGENTA="$ESC[35m"
CYAN="$ESC[36m"
RESET="$ESC[0m" # really 39, but don't I alwasy want reset_all?
RESET_ALL="$ESC[0m"

# printing a colored status line
# status <color> <message>
status () {
    if [ $# -ne 2 ]; then
        echo -e "${RED}*** ERROR: status <color> <message> ***${RESET}"
        exit 1
    fi
    echo -e "$1 $2 ${RESET_ALL}"
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
        echo -e "${RED}*** ERROR: OS is not Linux ***${RESET}"
        exit 1
    fi
}

# this will fail if the user ID is not 0 (root)
fail_not_root () {
    if [ `id -u` != "0" ]; then
        echo -e "${RED}*** ERROR: User is not ROOT ***${RESET}"
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