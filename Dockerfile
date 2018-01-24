
FROM alpine:latest
LABEL MAINTAINER="Adam Drozdz <adrozdz@container-labs.com>"
LABEL NAME="postgres-sync"

ENV PGHOST_IN=default \
    PGPORT_IN= \
    PGUSER_IN= \
    PGPASSWORD_IN= \
    PGHOST_OUT= \
    PGPORT_OUT= \
    PGUSER_OUT= \
    PGPASSWORD_OUT= 
  

ENV PACKAGES="postgresql bash"

RUN apk add --no-cache $PACKAGES
RUN mkdir /data

ADD ./migration.sh /migration.sh

WORKDIR /

ENTRYPOINT ["/migration.sh"]
