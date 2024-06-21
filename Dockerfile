FROM alpine:3.20

LABEL org.opencontainers.image.authors="Sander Timmerman <stimmerman@users.noreply.github.com>"
LABEL org.opencontainers.image.source="https://github.com/stimmerman/netshoot"
LABEL org.opencontainers.image.documentation="https://github.com/stimmerman/netshoot"
LABEL org.opencontainers.image.description="Container filled with network debugging tools."

EXPOSE 80 443

RUN apk update \
    &&  apk add apache2-utils bash bind-tools busybox-extras curl ethtool git \
                iperf3 iproute2 iputils jq lftp mtr mysql-client \
                netcat-openbsd net-tools nginx nmap nmap-scripts openssh-client openssl \
                perl-net-telnet postgresql-client procps rsync socat \
                tcpdump tcptraceroute tshark wget \
    &&  mkdir /certs \
    &&  chmod 700 /certs \
    &&  openssl req \
        -x509 -newkey rsa:2048 -nodes -days 3650 \
        -keyout /certs/server.key -out /certs/server.crt -subj '/CN=localhost'

COPY nginx.conf /etc/nginx/nginx.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

ENTRYPOINT ["/bin/sh", "/docker-entrypoint.sh"]