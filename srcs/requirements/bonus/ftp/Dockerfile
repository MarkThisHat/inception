FROM alpine:3.20

ARG FTP_USER
ARG FTP_PASSWORD
ARG FTP_PATH

RUN apk update && apk add --no-cache vsftpd

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN mkdir -p /var/log \
	&& touch /var/log/vsftpd.log

RUN adduser -D -g "" --home /home/$FTP_USER --shell /bin/ash $FTP_USER 
RUN echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

RUN echo -e "\nlocal_root=$FTP_PATH" >> /etc/vsftpd/vsftpd.conf

EXPOSE 21

ENTRYPOINT [ "vsftpd", "/etc/vsftpd/vsftpd.conf" ]