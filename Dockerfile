FROM golang:1.7-alpine

MAINTAINER 13yo
# ENV PATH /go/bin:/usr/local/go/bin:$PATH
# ENV GOPATH /go

RUN mkdir -p /opt/cfssl/certs
VOLUME /opt/cfssl/certs

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
    apk del .build-deps

COPY entrypoint.sh /opt/cfssl/entrypoint.sh
RUN chmod a+x /opt/cfssl/entrypoint.sh

USER cfssl    
WORKDIR /opt/cfssl

COPY config/ca.json /opt/cfssl/certs/ca.json
COPY config/config.json /opt/cfssl/certs/config.json

CMD ["/opt/cfssl/entrypoint.sh"]
