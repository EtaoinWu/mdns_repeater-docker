#!/bin/bash

if [ "${USE_MDNS_REPEATER}" -eq 1 ]; then
  if [ "${DOCKER_NETWORK_NAME}" = "bridge" ]; then
    echo "Starting repeater with the default bridge network..."
    
    exec mdns-repeater -f ${OPTIONS} "${EXTERNAL_INTERFACE}" "docker0"
  else
    # This searches the list of docker networks for the network name in order to get the ID, then (below) uses that ID
    # to infer the docker interface name.
    DOCKER_INTERFACE=$(docker network list | grep "${DOCKER_NETWORK_NAME}" | awk '{print $1}')
    
    echo "Starting repeater with network ${DOCKER_NETWORK_NAME},"
    echo "Found bridge br-${DOCKER_INTERFACE}"
    
    # Below is for future use in case I want to try to auto-detect the external interface
    #NON_VIRTUAL_INTERFACES=($(ip addr | grep "state UP" -A2 | awk '/inet/{print $(NF)}' | grep -P '^(?:(?!veth).)*$' | tr '\n' ' '))

    exec mdns-repeater -f ${OPTIONS} "${EXTERNAL_INTERFACE}" "br-${DOCKER_INTERFACE}"
  fi
else
  # If the local user has disabled the app, then just sleep forever
  sleep infinity
fi
