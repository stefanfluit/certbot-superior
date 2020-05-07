#!/usr/bin/env bash

# This script makes sure that all the files are in the right directories. 

# Set Bash behaviour
set -o errexit      #Exit on uncaught errors
set -o pipefail 	#Fail pipe on first error

# Run with --update flag to update all files. 

if [ "${1}" == '--update' ]; then
    cd /var/lib/repos/cerbot-superior && git pull --recurse-submodules
    cp -a /var/lib/repos/certbot-superior/scripts/. /var/lib/scripts
    cp -a /var/lib/repos/certbot-superior/scripts/. /var/lib/scripts
    systemctl daemon-reload
else
    mkdir -pv /var/lib/scripts
    cp -a /var/lib/repos/certbot-superior/scripts/. /var/lib/scripts/
    cp -a /var/lib/repos/certbot-superior/systemd/. /etc/systemd/system/
    systemctl daemon-reload && systemctl start certbot-superior.timer
    systemctl enable certbot-superior.timer
    printf "Setup done, make sure to edit the domain_names file in the repo/files.\n"
fi
