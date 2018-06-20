#!/bin/bash
echo 1
./webmail-start.sh &
echo 12
./imap-start.sh &
echo 20
smtp-sink -c -d /home/smtp/Maildir/new/%M. -u smtp 0.0.0.0:8025 10
echo 30