#!/bin/bash

IP=127.0.0.1
USER=developer
PROJECT=mail-sink
GIT_REPO=https://github.com/gibbsoft/mail-sink.git
GIT_REF=master

oc login https://${IP}:8443 -u $USER

oc project ${PROJECT}

oc delete all -l app=mail-sink

oc new-app -f template.yml \
    -p APPLICATION_NAME=mail-sink \
    -p SOURCE_REPOSITORY_URL=${GIT_REPO} \
    -p SOURCE_REPOSITORY_REF=${GIT_REF} \
    -p DOCKERFILE_PATH="." \
    -p MEMORY_LIMIT=1Gi
