FROM alpine:latest
MAINTAINER Peter Foreman <peter@frmn.nl>

RUN apk update && apk add whois curl bash
COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

CMD [ "/entrypoint.sh" ]
