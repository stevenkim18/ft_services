FROM alpine:latest

ARG IP

RUN apk update


RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli \
	php7-zlib php7-curl php7-mbstring php7-json php7-session
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz
RUN rm -f latest.tar.gz
RUN mv wordpress /etc/
COPY wp-config.php /etc/wordpress/

RUN apk add mysql-client
COPY wordpress.sql /tmp/
COPY init-wordpress.sh /tmp/

RUN sed -i "s/MINIKUBE_IP/$IP/g" /etc/wordpress/wp-config.php

EXPOSE 5050

RUN rm -rf /var/cache/apk/*
COPY run.sh /tmp/
ENTRYPOINT ["sh", "/tmp/run.sh"]