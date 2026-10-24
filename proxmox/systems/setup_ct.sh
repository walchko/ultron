#!/bin/bash
# MIT License Kevin Walchko (c) 2024
# script.sh <password>

# check if we are root
if [[ "${EUID}" != "0" || "${USER}" != "root" ]]; then
    echo "Please run as root"
    exit 1
fi

if [[ $# -eq 1 ]]; then
    PASSWD=$1
else
    echo "ERROR: script.sh <password>"
    exit 1
fi


cat << "EOF"
 ____       _                  ____ _____
/ ___|  ___| |_ _   _ _ __    / ___|_   _|
\___ \ / _ \ __| | | | '_ \  | |     | |
 ___) |  __/ |_| |_| | |_) | | |___  | |
|____/ \___|\__|\__,_| .__/   \____| |_|
                     |_|

EOF

