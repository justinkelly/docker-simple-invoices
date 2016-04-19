FROM alpine:latest
MAINTAINER Justin Kelly <justin@kelly.org.au>

LABEL caddy_version="0.8.2" architecture="amd64"

RUN apk add --update openssh-client git tar php-fpm

# essential php libs
RUN apk add php-curl php-gd php-iconv php-mysql php-mysqli php-json php-xml ssmtp

# allow environment variable access.
RUN echo "clear_env = no" >> /etc/php/php-fpm.conf

RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/build?os=linux&arch=amd64" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
 && chmod 0755 /usr/bin/caddy \
 && /usr/bin/caddy -version

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

# Add image configuration and scripts
ADD s3 /s3
ADD run.sh /run.sh
RUN chmod 755 /*.sh
RUN 'chmod -Rf 777 /srv/tmp'
#RUN /run.sh

ADD simpleinvoices/ /srv
ADD ssmtp.conf /etc/ssmtp/ssmtp.conf

EXPOSE 80 443 2015

WORKDIR /srv

ADD Caddyfile /etc/Caddyfile

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile"]
#CMD ["/run.sh"]
