FROM alpine:3.18 as bind9

RUN apk --update --no-cache add \
    bind=9.18.16-r0 

RUN mkdir -p /var/run/named && chown root:named /var/run/named && chmod 770 /var/run/named

FROM scratch

COPY --from=bind9 / /

VOLUME [ "/var/bind", "/etc/bind" ]

EXPOSE 53/tcp 53/udp 953/tcp

ENTRYPOINT [ "/usr/sbin/named" ]
CMD [ "-g", "-f", "-c", "/etc/bind/named.conf", "-u", "named" ]