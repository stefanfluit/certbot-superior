#!/usr/bin/env bash

# Setting Bash behaviour to make sure the script will exit on error, we want to prevent useless API calls.
set -exo pipefail

# Usage:
# Initiated by Systemd, but you can run this manually for testing purposes. Add --test flag and domain to test, eg "./certbot-auto-renew.sh --test webserver.example.com"

# Variables
declare admin_email
admin_email="admin.example.com"
# Variable to house the test domain variable.
declare test_domain
test_domain="${2}"

# Define array of domains to loop through, passed through parameters from test-date.sh.
declare -a domain_names=("${@}")

if [ "${1}" == '--test' ]; then
    ./certbot-auto certonly --manual --preferred-challenges=dns --manual-auth-hook /var/lib/scripts/prehook.sh --manual-cleanup-hook /var/lib/scripts/cleanup.sh -d "${test_domain}" --dry-run --non-interactive --manual-public-ip-logging-ok --agree-tos --email "${admin_email}"
else
  for domain_name in "${domain_names[@]}"; do
    ./certbot-auto certonly --manual --preferred-challenges=dns --manual-auth-hook /var/lib/scripts/prehook.sh --manual-cleanup-hook /var/lib/scripts/cleanup.sh -d "${domain_name}" --non-interactive --manual-public-ip-logging-ok --agree-tos --email "${admin_email}"
  done
fi
