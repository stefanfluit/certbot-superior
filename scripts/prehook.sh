#!/usr/bin/env bash

# A simple prehook script to add the generated TXT value to Superior DNS via their API. 
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

# This variable holds the amount of seconds to wait for TTL to pass. Change this if needed.
declare wait_ttl
wait_ttl="180"

# Making sure that, in the terminal view, there will be a notification that this script is running, or the sleep command might look stuck.
printf "Started TXT update process for %s.\n" "${CERTBOT_DOMAIN}"

# Posting the new TXT value
# Using Curl command to to post the new data. $CERTBOT_x variables are set by Certbot. Sleeping after to wait for TTL to pass. 
curl --data \
"customer_id=${user_token}&key=${api_token}&action=add-ns-record&domain=${CERTBOT_DOMAIN}&type=TXT&host=_acme-challenge&content=$CERTBOT_VALIDATION" \
 -X POST https://www.klantsysteem.nl/api/ && sleep "${wait_ttl}"

declare resolve_txt
resolve_txt="$(dig +short txt _acme-challenge."${CERTBOT_DOMAIN}")"

# Using if statements to verify the new TXT record, and stopping if it is not working, then certbot will not create a request.
if [ "${resolve_txt}" == "${CERTBOT_VALIDATION}" ]; then
    printf "TXT Record updated.\n"
else
    printf "TXT Record not updated.\n"
    exit
fi
