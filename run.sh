#!/bin/sh
set -e

#/s3 --region "${AWS_REGION}" sync s3://docker-files.invoice.im/${DOMAIN}/logo/ /app/templates/invoices/logos/
#/s3 --region "${AWS_REGION}" sync s3://docker-files.invoice.im/${DOMAIN}/template/ /app/templates/invoices/


echo "mailhub=${SMTP_HOST}:${SMTP_PORT}" > /etc/ssmtp/ssmtp.conf
echo "AuthUser=${SMTP_USER}" >> /etc/ssmtp/ssmtp.conf
echo "AuthPass=${SMTP_PASS}" >> /etc/ssmtp/ssmtp.conf
echo "UseSTARTTLS=YES" >> /etc/ssmtp/ssmtp.conf

# display logs
tail -F /var/log/apache2/*log &

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2.pid

/usr/sbin/apache2ctl -D FOREGROUND
