
FROM alpine

ADD mdns-repeater.c mdns-repeater.c

RUN apk add --no-cache build-base bash docker-cli \
    && gcc -O3 -o /bin/mdns-repeater mdns-repeater.c -DHGVERSION="\"1\"" \
    && apk del build-base \
    && rm -rf /var/cache/apk/* /tmp/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x entrypoint.sh

# Whether or not to enable repeating
ENV USE_MDNS_REPEATER=1

# EXTERNAL_INTERFACE is the interface name of the external (host) interface
ENV EXTERNAL_INTERFACE=eth0

# DOCKER_NETWORK_NAME is the name of the docker network that we want to bridge
# (used to look up the bridge network name)
ENV DOCKER_NETWORK_NAME=bridge

# OPTIONS are (optional) options to be passed to mdns-repeater
ENV OPTIONS=

ENTRYPOINT [ "/entrypoint.sh" ]
