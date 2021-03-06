FROM alpine:edge
MAINTAINER Justin Kelly <justin@kelly.org.au>

LABEL caddy_version="0.8.2" architecture="amd64"

RUN apk add --update caddy php-fpm 

# essential php libs
RUN apk add openssl \
	openssl-dev \
 	php-openssl \
	php-pdo \
	php-pdo_mysql \
	php-curl \
	php-imap \
	php-gd \
	php-mcrypt \
	php-iconv \
	php-mysql \
	php-mysqli \
	php-json \
	php-xml \
	php-ctype \
	php-xsl ssmtp

#certs
RUN apk --update upgrade && \
    apk add curl ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*
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
RUN sed -i -e "s/group = nobody/group = www-data/g" /etc/php/php-fpm.conf && \
sed -i -e "s/user = nobody/user = www-data/g" /etc/php/php-fpm.conf 

EXPOSE 80 443 2015

WORKDIR /srv


#ENTRYPOINT ["/usr/bin/caddy"]
#CMD ["--conf", "/etc/Caddyfile"]
CMD ["/run.sh"]
