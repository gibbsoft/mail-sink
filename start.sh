#!/bin/bash


cat /etc/passwd | sed 's/1001/1000120000/g' > /tmp/passwd

cat /tmp/passwd > /etc/passwd

./webmail-start.sh &

./imap-start.sh &

smtp-sink -c -d /home/smtp/Maildir/new/%M. 0.0.0.0:8025 10
