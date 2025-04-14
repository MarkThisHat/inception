FROM alpine:3.18

RUN apk update && apk add --no-cache nginx openssl openrc

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /etc/nginx/ssl && \
	openssl req -newkey rsa:2048 -nodes \
	-keyout /etc/nginx/ssl/private.key \
	-x509 -days 365 \
	-out /etc/nginx/ssl/certificate.pem \
	-subj "/C=BR/ST=SP/L=SãoPaulo/O=42sp/CN=maalexan.42.fr"

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]
