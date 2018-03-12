FROM debian:latest
MAINTAINER Peter Foreman <peter@frmn.nl>

COPY entrypoint.sh /
RUN apt-get update && apt-get -y upgrade && apt-get -y install whois
RUN chmod 755 /entrypoint.sh

CMD [ "/entrypoint.sh" ]
