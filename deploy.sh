#!/bin/bash

IP=ocp.datr.eu
USER=justin
PROJECT=mail

oc login https://${IP}:8443 -u $USER

oc project ${PROJECT}

oc delete all -l app=mail-sink

oc new-app -f template.yml \
    -p APPLICATION_NAME=mail-sink \
    -p SOURCE_REPOSITORY_URL=https://github.com/justindav1s/mail-sink.git \
    -p SOURCE_REPOSITORY_REF=master \
    -p DOCKERFILE_PATH="." \
    -p MEMORY_LIMIT=1Gi