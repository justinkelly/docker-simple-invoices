#!/bin/sh

#/s3 --region "${AWS_REGION}" sync s3://docker-files.invoice.im/${DOMAIN}/logo/ /app/templates/invoices/logos/
#/s3 --region "${AWS_REGION}" sync s3://docker-files.invoice.im/${DOMAIN}/template/ /app/templates/invoices/

#chown -Rf www-data:www-data /srv/tmp*

exec caddy --conf /etc/Caddyfile
