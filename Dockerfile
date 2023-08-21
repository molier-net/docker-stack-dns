FROM alpine:3.18 as bind9

# renovate: datasource=repology depName=alpine_3_18/bind versioning=loose
ARG BIND9_VERSION="9.18.16-r0"

RUN apk --update --no-cache add \
    bind=${BIND9_VERSION}

RUN mkdir -p /var/run/named && chown root:named /var/run/named && chmod 770 /var/run/named

FROM scratch

COPY --from=bind9 / /

VOLUME [ "/var/bind", "/etc/bind" ]

EXPOSE 53/tcp 53/udp 953/tcp

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "/usr/sbin/rndc","status" ]

ENTRYPOINT [ "/usr/sbin/named" ]
CMD [ "-g", "-f", "-c", "/etc/bind/named.conf", "-u", "named" ]