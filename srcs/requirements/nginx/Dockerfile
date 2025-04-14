FROM alpine:3.20

ARG DOMAIN_NAME
ENV DOMAIN_NAME=${DOMAIN_NAME}

RUN apk update && apk add --no-cache nginx openssl gettext

RUN mkdir -p /etc/nginx/ssl && \
	openssl req -newkey rsa:2048 -nodes \
	-keyout /etc/nginx/ssl/private.key \
	-x509 -days 365 \
	-out /etc/nginx/ssl/certificate.pem \
	-subj "/C=BR/ST=SP/L=SãoPaulo/O=42sp/CN=${DOMAIN_NAME}"

COPY ./conf/nginx.conf.template /etc/nginx/nginx.conf.template

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
