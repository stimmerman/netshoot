FROM alpine:3.20

LABEL org.opencontainers.image.authors="Sander Timmerman <stimmerman@users.noreply.github.com>"
LABEL org.opencontainers.image.source="https://github.com/stimmerman/netshoot"
LABEL org.opencontainers.image.documentation="https://github.com/stimmerman/netshoot"
LABEL org.opencontainers.image.description="Container filled with network debugging tools."

ARG S6_OVERLAY_VERSION=3.2.0.0

RUN apk update && \
    apk add \
        apache2-utils \
        bash \
        bind-tools \
        busybox-extras \
        curl \
        ethtool \
        git \
        iperf3 \
        iproute2 \
        iputils \
        jq \
        lftp \
        mtr \
        mysql-client \
        net-tools \
        netcat-openbsd \
        nginx \
        nmap \
        nmap-scripts \
        nodejs \
        npm \
        openssh-client \
        openssl \
        perl-net-telnet \
        postgresql-client \
        procps \
        rsync \
        socat \
        tcpdump \
        tcptraceroute \
        tshark \
        wget \
    &&  mkdir /certs \
    &&  chmod 700 /certs \
    &&  openssl req \
        -x509 -newkey rsa:2048 -nodes -days 3650 \
        -keyout /certs/server.key -out /certs/server.crt -subj '/CN=localhost'

COPY root/ /
RUN cd /parrot && npm install

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

EXPOSE 80 443

ENTRYPOINT ["/init"]