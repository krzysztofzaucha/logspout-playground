# This file has been redone according to the original ones found in the following:
# - https://github.com/gliderlabs/logspout/blob/master/Dockerfile
# - https://github.com/gliderlabs/logspout/blob/master/build.sh
# - https://github.com/dsouzajude/logspout-fluentd

FROM alpine:3.14

RUN apk add --update go build-base git mercurial ca-certificates

ADD tmp/gliderlabs/logspout-master /src
ADD logspout/modules.go /src/modules.go
ADD logspout/entrypoint.sh /entrypoint.sh

WORKDIR /src

RUN go get github.com/dsouzajude/logspout-fluentd/fluentd \
    && go get github.com/gliderlabs/logspout/httpstream \
    && go build -ldflags "-X main.Version=$(cat VERSION)" -o /bin/logspout

WORKDIR /bin

RUN apk del go git mercurial build-base

RUN rm -rf /root/go /var/cache/apk/*

EXPOSE 80

VOLUME /mnt/routes

#ENTRYPOINT /entrypoint.sh
