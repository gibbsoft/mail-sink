#!/bin/bash

IP=ocp.datr.eu
USER=justin
PROJECT=mail

oc login https://${IP}:8443 -u $USER

oc project ${PROJECT}

oc get pod/mail-sink-5-x4kjc \
    -o jsonpath="{.spec.containers[0].securityContext.runAsUser}" \
"1000120000"