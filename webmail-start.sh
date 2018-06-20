#!/bin/bash

echo 2
#./generate-certs.sh
echo 6
. /etc/apache2/envvars
echo 7
/etc/init.d/courier-authdaemon start
echo 8
/etc/init.d/sqwebmail start
echo 9
rm -fr /var/run/apache2/*
echo 10
apache2 -DFOREGROUND
echo 11
