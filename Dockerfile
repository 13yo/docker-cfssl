FROM cfssl:cfssl
MAINTAINER 13yo
ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go

VOLUME /cfssl

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
