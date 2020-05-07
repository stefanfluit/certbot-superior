#!/usr/bin/env bash

# Setting Bash behaviour to make sure the script will exit on error, we want to prevent useless API calls.
set -exo pipefail

# Usage:
# Initiated by Systemd, but you can run this manually for testing purposes. Add --test flag and domain to test, eg "./certbot-auto-renew.sh --test webserver.example.com"

# Variables
# This is the path to the certbot repo. I expect it in /var/lib/repos.
declare DIR_
DIR_="/var/lib/repos/certbot"
declare admin_email
admin_email="admin.example.com"
# Variable to house the test domain variable.
declare test_domain
test_domain="${2}"

# CD into working directory and exit if not found. 
cd "${DIR_}" || printf "Error, %s not found\n" "${DIR_}" && exit 

# Import array of domains to loop through.
declare variable_file
variable_file="/var/lib/repos/certbot-superior/files/domain_names.txt"
readarray -t domain_names < "${variable_file}"

if [ "${1}" == '--test' ]; then
    ./certbot-auto certonly --manual --preferred-challenges=dns --manual-auth-hook /var/lib/scripts/prehook.sh --manual-cleanup-hook /var/lib/scripts/cleanup.sh -d "${test_domain}" --dry-run --non-interactive --manual-public-ip-logging-ok --agree-tos --email "${admin_email}"
else
  for domain_name in "${domain_names[@]}"; do
    ./certbot-auto certonly --manual --preferred-challenges=dns --manual-auth-hook /var/lib/scripts/prehook.sh --manual-cleanup-hook /var/lib/scripts/cleanup.sh -d "${domain_name}" --non-interactive --manual-public-ip-logging-ok --agree-tos --email "${admin_email}"
  done
fi
