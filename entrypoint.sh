#!/bin/bash

if [ ! -f /cfssl/ca.pem ]
  then
    cd /cfssl
    cfssl genkey -initca /opt/cfssl/ca.json | cfssljson -bare ca
fi

echo "Starting cfssl server"
exec cfssl serve -loglevel=0 -address 0.0.0.0 -config /opt/cfssl/config.json -ca /cfssl/ca.pem -ca-key /cfssl/ca-key.pem > /var/log/cfssl.log
