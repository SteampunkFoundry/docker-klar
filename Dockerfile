ARG alpine_version=3.12
FROM alpine:${alpine_version}
ARG klar_version=2.4.0

RUN apk add --no-cache wget ca-certificates
RUN wget -nv https://github.com/optiopay/klar/releases/download/v${klar_version}/klar-${klar_version}-linux-amd64 -O /klar \
    && chmod +x /klar
RUN apk del --no-cache wget

ENTRYPOINT ["/klar"]
