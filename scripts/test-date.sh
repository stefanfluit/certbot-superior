#!/usr/bin/env bash

# This script makes sure that, the domains we want to generate certificates for, are actually almost expired. 

# Setting Bash behaviour to make sure the script will exit on error.
# No fail on unset variables since that would break the script because Certbot will set $CERTBOT_x variables.
set -exo pipefail

# Import array of domains to loop through.
declare variable_file
variable_file="/var/lib/repos/certbot-superior/files/domain_names.txt"
readarray -t domain_names < "${variable_file}"

for domain_name in "${domain_names[@]}"; do
    declare certificate_file
    certificate_file=$(mktemp)
    echo -n | openssl s_client -servername "${domain_name}" -connect "${domain_name}":443 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > "${certificate_file}"
    declare date
    date=$(openssl x509 -in "${certificate_file}" -enddate -noout | sed "s/.*=\(.*\)/\1/")
    declare date_s
    date_s=$(date -d "${date}" +%s)
    declare now_s
    now_s=$(date -d now +%s)
    declare date_diff
    date_diff=$(( (date_s - now_s) / 86400 ))
    declare days_to_renew
    days_to_renew="7"
    # Print out the amount of days. If it equeals less than seven, we will go for a renewal. 
    printf "%s will expire in %s days\n" "${domain_name}" "${date_diff}"
    if [ "${date_diff}" -gt "${days_to_renew}" ]; then
        printf "No need to renew certificate.\n"
        exit
    else
        sh -c /var/lib/scripts/certbot-auto-renew.sh "${domain_name}"
    fi
done