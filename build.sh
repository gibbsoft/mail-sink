#!/bin/bash

docker build -t "mail-sink:dockerfile" .


IP=127.0.0.1
USER=developer
PROJECT=mail
IMAGE=mailsink:latest
REGISTRY_HOST=docker-registry-default.127.0.0.1.nip.io:5000

oc login https://${IP}:8443 -u $USER

oc project ${PROJECT}

docker build -t $IMAGE .
docker tag $IMAGE $REGISTRY_HOST/${PROJECT}/$IMAGE

TOKEN=`oc whoami -t`

docker login -p $TOKEN -u justin $REGISTRY_HOST

sleep 5

docker push $REGISTRY_HOST/${PROJECT}/$IMAGE
