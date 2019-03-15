#!/usr/bin/env bash
set -o

wget https://letsencrypt.org/certs/fakelerootx1.pem
openssl x509 -in fakelerootx1.pem -inform PEM -out fakelerootx1.crt
mkdir -p /usr/share/ca-certificates/extra
mv fakelerootx1.crt /usr/share/ca-certificates/extra/fakelerootx1.crt
dpkg-reconfigure ca-certificates
update-ca-certificates