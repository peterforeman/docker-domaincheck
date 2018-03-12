#!/bin/bash
# DOMAINS = domain,domain,domain
# PUSHOVER_TOKEN = aeos21t1z7vags3dqndrvpg1mhafuv
# PUSHOVER_USER = u2uaVFguZ7r6XiBukmhnGvx7RroKba
# SLEEP = 86400

echo "Domaincheck starting!"
echo "Domains	: ${DOMAINS}"
echo "Pushtoken : ${PUSHOVER_TOKEN}"
echo "Push user : ${PUSHOVER_USER}"

# Name: Check for domain name availability
IFS=', ' read -r -a doms <<< "${DOMAINS}"

while [ 1 ];
do 
    for element in "${doms[@]}";
    do
    	echo "Checking domain $element"
    	
        whois $element | egrep -q '^No match|^NOT FOUND|^Not fo|AVAILABLE|^No Data Fou|has not been regi|No entri|is free'
            if [ $? -eq 0 ]; then
                echo "Domain $element is available!"
                curl -s \
                    --form-string "token=${PUSHOVER_TOKEN}" \
                    --form-string "user={$PUSHOVER_USER}" \
                    --form-string "message=$element is available!" \
                    https://api.pushover.net/1/messages.json
            fi
    done

    echo "Sleeping ${SLEEP} seconds"    
    sleep ${SLEEP}
done
