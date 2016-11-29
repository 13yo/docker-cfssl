FROM golang:1.7-alpine

MAINTAINER 13yo
# ENV PATH /go/bin:/usr/local/go/bin:$PATH
# ENV GOPATH /go

VOLUME /cfssl

#RUN apt-get update && \
#    apt-get upgrade -y && \
#    apt-get install -y \
#    golang \
#    gcc \
#    git &&\
#    echo "Prerequesites installed"

RUN apk add --no-cache --virtual .build-deps git g++ gcc libc6-dev && \
    echo "Building cfssl" && \
    go get -u github.com/cloudflare/cfssl/cmd/cfssl && \
    echo "Building cfssl toolset" && \
    go get -u github.com/cloudflare/cfssl/cmd/... && \
    echo "Build complete" && \
    apk del .build-deps

RUN groupadd -r cfssl -g 433 && \
    useradd -u 431 -r -g cfssl -d /opt/cfssl -s /sbin/nologin -c "CFSSL daemon account" cfssl && \
    mkdir -p /opt/cfssl && \
    chown -R cfssl:cfssl /opt/cfssl && \
    chown -R cfssl:cfssl /cfssl

COPY entrypoint.sh /opt/cfssl/entrypoint.sh
RUN chmod a+x /opt/cfssl/entrypoint.sh

USER cfssl    
WORKDIR /cfssl

COPY config/ca.json /cfssl/ca.json
COPY config/config.json /cfssl/config.json

CMD ["/opt/cfssl/entrypoint.sh"]
