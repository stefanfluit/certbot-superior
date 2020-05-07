#!/usr/bin/env bash

# A simple cleanup script to remove the generated TXT value to Superior DNS via their API. 
# To update token simply edit the variable. 
# Documentation can be aquired via Superior support.

# Setting Bash behaviour to make sure the script will exit on error, we want to prevent useless API calls.
# No fail on unset variables since that would break the script because Certbot will set $CERTBOT_x variables.
set -exo pipefail

# Lower case variables declared here, upper case variables are set by Certbot.
# API Variables
declare api_token
api_token="<API TOKEN>"
declare user_token
user_token="<Customer ID>"

# Variable to define a writable directory and filename for a temporary JSON file.
declare json_tmp
json_tmp="/tmp/report.json"

# Making sure that, in the terminal view, there will be a notification that this script is running.
printf "Started TXT removal process for %s.\n" "${CERTBOT_DOMAIN}"

# Curling the output to a file to parse with jq, let's find the id so we can remove it. This is mandatory, can not use CERTBOT_VALIDATION var. See Superior documentation page 23 2.16 del-ns-record.
curl --data "customer_id=${user_token}&key=${api_token}&action=show-ns-records&domain=${CERTBOT_DOMAIN}&type=txt" -X POST https://www.klantsysteem.nl/api/ > "${json_tmp}"
declare remove_txt_id
remove_txt_id=$(cat "${json_tmp}" | jq .records | grep _acme -B2 | grep id | grep --only-matching '[0-9]*')

# Removing the used TXT value
# Using Curl command to to remove the used record. $CERTBOT_x variables are set by Certbot.
curl --data \
"customer_id=${user_token}&key=${api_token}&action=del-ns-record&domain=${CERTBOT_DOMAIN}&record_id=${remove_txt_id}" \
 -X POST https://www.klantsysteem.nl/api/ 