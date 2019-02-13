FROM alpine:3.8
COPY ./VERSION VERSION
RUN if test "$(uname -m)" = "aarch64" ; then ARCH="arm64"; else ARCH="amd64"; fi && \
    VERSION=$(cat VERSION) && \
    apk add --update ca-certificates openssl tar && \
    wget https://github.com/etcd-io/etcd/releases/download/${VERSION}/etcd-${VERSION}-linux-${ARCH}.tar.gz && \
    tar xzvf etcd-${VERSION}-linux-${ARCH}.tar.gz && \
    mv etcd-${VERSION}-linux-${ARCH}/etcd* /bin/ && \
    apk del --purge tar openssl && \
    rm -Rf etcd-${VERSION}-linux-${ARCH}* /var/cache/apk/*
RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

EXPOSE 2379 2380

CMD  ["/bin/etcd"]
