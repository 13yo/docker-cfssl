if [ ! -f /cfssl/ca.pem ]
  then
    cd /cfssl
    cfssl genkey -initca /cfssl/ca.json | cfssljson -bare ca
fi

#!/usr/bin/env bash
echo "Starting cfssl server"
exec cfssl serve -address 0.0.0.0 -config /cfssl/config.json -ca /cfssl/ca.pem -ca-key /cfssl/ca-key.pem $@
