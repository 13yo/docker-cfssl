FROM golang:1.7-alpine

MAINTAINER 13yo
# ENV PATH /go/bin:/usr/local/go/bin:$PATH
# ENV GOPATH /go
# ENV USER root
# USER root

# RUN mkdir -p /cfssl
VOLUME ["/cfssl"]

#RUN apt-get update && \
#    apt-get upgrade -y && \
#    apt-get install -y \
#    golang \
#    gcc \
#    git &&\
#    echo "Prerequesites installed"

RUN apk add --no-cache bash
RUN apk add --no-cache --virtual .build-deps \ 
        git \
        gcc \
	musl-dev \
	openssl && \
    echo "Building cfssl" && \
    go get -u github.com/cloudflare/cfssl/cmd/cfssl && \
    echo "Building cfssl toolset" && \
    go get -u github.com/cloudflare/cfssl/cmd/... && \
    echo "Build complete" && \
    mkdir -p /opt/cfssl && \
    apk del .build-deps

COPY entrypoint.sh /opt/cfssl/entrypoint.sh
RUN chmod a+x /opt/cfssl/entrypoint.sh
   
COPY config/ca.json /opt/cfssl/ca.json
COPY config/config.json /opt/cfssl/config.json

CMD ["/opt/cfssl/entrypoint.sh"]
