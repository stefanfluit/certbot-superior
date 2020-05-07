#!/usr/bin/env bash

# This script makes sure that all the files are in the right directories. 

# Setting Bash behaviour to make sure the script will exit on error.
set -exo pipefail

# Run with --update flag to update all files. 

if [ "${1}" == '--update' ]; then
    cd /var/lib/repos/cerbot-superior && git pull --recurse-submodules
    cp -a /var/lib/repos/certbot-superior/scripts/. /var/lib/scripts
    cp -a /var/lib/repos/certbot-superior/scripts/. /var/lib/scripts
    systemctl daemon-reload
else
    declare YUM_CMD
    YUM_CMD=$(which yum)
    declare APT_GET_CMD
    APT_GET_CMD=$(which apt-get)
    if [[ -n "${YUM_CMD}" ]]; then
        yum install -y openssl curl git
    elif [[ -n $APT_GET_CMD ]]; then
        apt-get install -y openssl curl git
    fi
    mkdir -pv /var/lib/scripts
    mkdir -pv /var/lib/repos && git clone --recursive https://github.com/stefanfluit/certbot-superior.git
    cp -a /var/lib/repos/certbot-superior/scripts/. /var/lib/scripts/
    cp -a /var/lib/repos/certbot-superior/systemd/. /etc/systemd/system/
    systemctl daemon-reload && systemctl start certbot-superior.timer
    systemctl enable certbot-superior.timer
    printf "Setup done, make sure to edit the domain_names file in the repo/files.\n"
fi
