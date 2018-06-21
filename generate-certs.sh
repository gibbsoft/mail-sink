#!/bin/bash
set -x
echo 3
# Specify where we will install
# the xip.io certificate

SSL_DIR="/etc/apache2/ssl/"
# Set the wildcarded domain
# we want to use
DOMAIN="${FQDN}"

# A blank passphrase
PASSPHRASE=""

# Set our CSR variables
SUBJ="
C=US
ST=Connecticut
O=
localityName=New Haven
commonName=$DOMAIN
organizationalUnitName=
emailAddress=
"

# Create our SSL directory
# in case it doesn't exist
sudo mkdir -p "$SSL_DIR"

# Generate our Private Key, CSR and Certificate
sudo -u smtp openssl genrsa -out "$SSL_DIR/example.key" 2048
echo 4
sudo -u smtp openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/example.key" -out "$SSL_DIR/example.csr" -passin pass:$PASSPHRASE
echo 5
sudo -u smtp openssl x509 -req -days 365 -in "$SSL_DIR/example.csr" -signkey "$SSL_DIR/example.key" -out "$SSL_DIR/example.crt"
