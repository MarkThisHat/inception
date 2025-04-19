FROM alpine:3.20

RUN apk update && apk --no-cache add ca-certificates

RUN wget https://github.com/google/cadvisor/releases/download/v0.50.0/cadvisor-v0.50.0-linux-amd64 -O /usr/bin/cadvisor && \
    chmod +x /usr/bin/cadvisor

ENTRYPOINT [ "/usr/bin/cadvisor", "--port=8080" ]
