#!/bin/sh -e

#sleep 5

# todo: try to run the actual logspout command in the loop until it is successful...

#logspout "fluentd://${FLUENTD_HOST}:${FLUENTD_PORT}?filter.labels=service.group:primary"

# todo: try the following...

#until logspout "fluentd://${FLUENTD_HOST}:${FLUENTD_PORT}?filter.labels=service.group:primary"; do
#  >&2 echo "waiting for Fluentd to be ready..."
#  sleep 1
#done
