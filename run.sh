#!/bin/bash

/s3 --region "${AWS_REGION}" sync s3://docker-files.invoice.im/${DOMAIN}/logo/ /app/templates/invoices/logos/
/s3 --region "${AWS_REGION}" sync s3://docker-files.invoice.im/${DOMAIN}/template/ /app/templates/invoices/

exec /usr/bin/caddy --conf /etc/Caddyfile
