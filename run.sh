#!/bin/sh

#/s3 --region "${AWS_REGION}" sync s3://docker-files.invoice.im/${DOMAIN}/logo/ /app/templates/invoices/logos/
#/s3 --region "${AWS_REGION}" sync s3://docker-files.invoice.im/${DOMAIN}/template/ /app/templates/invoices/

chmod -Rf 775 /srv/tmp/log
chmod -Rf 775 /srv/tmp/cache

exec caddy --conf /etc/Caddyfile
