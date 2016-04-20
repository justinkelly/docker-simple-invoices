FROM alpine:edge
MAINTAINER Justin Kelly <justin@kelly.org.au>

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk --update add \
        php7-dom \
	php7-openssl \
        php7-ctype \
        php7-curl \
        php7-fpm \
        php7-gd \
        php7-intl \
        php7-json \
        php7-mbstring \
        php7-mysqli \
        php7-mysqlnd \
        php7-opcache \
        php7-iconv \
        php7-pdo \
        php7-pdo_mysql \
        php7-posix \
        php7-session \
        php7-sockets \
        php7-xml \	
        php7-xsl \	
	ssmtp \
    && rm -rf /var/cache/apk/*

RUN apk add --update caddy 

# allow environment variable access.
RUN echo "clear_env = no" >> /etc/php/php-fpm.conf

#RUN curl --silent --show-error --fail --location \
#      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
#      "https://caddyserver.com/download/build?os=linux&arch=amd64&features=git" \
#    | tar --no-same-owner -C /usr/bin/ -xz caddy \
# && chmod 0755 /usr/bin/caddy \
# && /usr/bin/caddy -version

#Si settings
ENV SI_AUTH="SI_AUTH"
ENV DB_HOST="DB_HOST"
ENV DB_NAME="DB_NAME"
ENV DB_PASS="DB_PASS"
ENV DB_PORT="3306"
ENV DB_USER="DB_USER"
ENV VIRTUAL_HOST="VIRTUAL_HOST"
ENV DOMAIN="DOMAIN"
ENV AWS_REGION="AWS_REGION"
ENV AWS_ACCESS_KEY_ID="AWS_ACCESS_KEY_ID"
ENV AWS_SECRET_ACCESS_KEY="AWS_SECRET_ACCESS_KEY"
ENV SMTP_HOST="SMTP_HOST"
ENV SMTP_PASS="SMTP_PASS"
ENV SMTP_USER="SMTP_USER"
ENV SMTP_PORT="SMTP_POST"
ENV SMTP_SECURE="SMTP_SECURE"

# Add config files
ADD s3 /s3
ADD run.sh /run.sh
ADD simpleinvoices/ /srv
ADD ssmtp.conf /etc/ssmtp/ssmtp.conf
ADD Caddyfile /etc/Caddyfile

RUN chmod 755 /*.sh
#RUN /run.sh
# ensure www-data user exists
RUN set -x \
	&& addgroup -g 82 -S www-data \
	&& adduser -u 82 -D -S -G www-data www-data
# 82 is the standard uid/gid for "www-data" in Alpine

# php-fpm user permissions
RUN chown -Rf www-data:www-data /srv/tmp
RUN sed -i -e "s/group = nobody/group = www-data/g" /etc/php7/php-fpm.conf && \
sed -i -e "s/user = nobody/user = www-data/g" /etc/php7/php-fpm.conf 

EXPOSE 80 443 2015

WORKDIR /srv


#ENTRYPOINT ["/usr/bin/caddy"]
#CMD ["--conf", "/etc/Caddyfile"]
CMD ["/run.sh"]
