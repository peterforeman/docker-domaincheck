#!/bin/bash
# DOMAINS = domain,domain,domain
# PUSHOVER_TOKEN = xxx
# PUSHOVER_USER = xxx
# SLEEP = 86400
# SMTP_FROM
# SMTP_FROMDOMAIN
# SMTP_TO
# SMTP_HOST

echo "Domaincheck starting!"
echo "Domains	     : ${DOMAINS}"
echo "Pushtoken      : ${PUSHOVER_TOKEN}"
echo "Push user      : ${PUSHOVER_USER}"
echo "SMTP host      : ${SMTP_HOST}"
echo "SMTP fromdomain: ${SMTP_FROMDOMAIN}"
echo "SMTP from      : ${SMTP_FROM}"
echo "SMTP to        : ${SMTP_TO}"

# Mail settings
echo "mailhub=${SMTP_HOST}" > /etc/ssmtp/ssmtp.conf
echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf
echo "domain=${SMTP_FROMDOMAIN}" >> /etc/ssmtp/ssmtp.conf
echo "rewriteDomain=${SMTP_FROMDOMAIN}" >> /etc/ssmtp/ssmtp.conf

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

                if [ "${PUSHOVER_TOKEN}" != "" ]; then
                    echo "Sending notification via Pushover"
                    curl -s \
                        --form-string "token=${PUSHOVER_TOKEN}" \
                        --form-string "user={$PUSHOVER_USER}" \
                        --form-string "message=$element is available!" \
                        https://api.pushover.net/1/messages.json
                fi

                if [ "${SMTP_TO}" != "" ]; then
                    echo "Sending mail..."
                    echo "To: ${SMTP_TO}\nSubject: Domain $element is available!\n\nDomain $element is available!\n" | sendmail -v -f ${SMTP_FROM} ${SMTP_TO}
                fi
            fi
    done

    echo "Sleeping ${SLEEP} seconds"    
    sleep ${SLEEP}
done
