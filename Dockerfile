FROM golang:1.17-alpine as build

RUN apk add --no-cache git

WORKDIR /app

RUN git clone https://github.com/showwin/speedtest-go /app && \
    go build -o /speedtest


FROM alpine:3.15

RUN apk add --no-cache jq bash python3 py3-pip && \
    pip3 install --upgrade pip && \
    pip3 install --no-cache-dir awscli && \
    rm -rf /var/cache/apk/*

COPY --from=build --chown=555 /speedtest /speedtest
COPY --chmod=775 entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
