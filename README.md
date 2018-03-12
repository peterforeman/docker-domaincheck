# docker-domaincheck

Docker container to regularly check status of domain names and notify you by Pushover when a domainname becomes free.

## Environment variables
### DOMAINS = domain,domain,domain

Comma or space seperated list of domains to check

### PUSHOVER_TOKEN = xxx

Pushover API token

### PUSHOVER_USER = xxx

Pushover user token

### SLEEP = 86400

Seconds to sleep between checks
