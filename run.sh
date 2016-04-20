#!/bin/sh

#/s3 --region "${AWS_REGION}" sync s3://docker-files.invoice.im/${DOMAIN}/logo/ /app/templates/invoices/logos/
#/s3 --region "${AWS_REGION}" sync s3://docker-files.invoice.im/${DOMAIN}/template/ /app/templates/invoices/


echo "mailhub=${SMTP_HOST}:${SMTP_PORT}" > /etc/ssmtp/ssmtp.conf
echo "AuthUser=${SMTP_USER}" >> /etc/ssmtp/ssmtp.conf
echo "AuthPass=${SMTP_PASS}" >> /etc/ssmtp/ssmtp.conf
echo "UseSTARTTLS=YES" >> /etc/ssmtp/ssmtp.conf

# set apache as owner/group
if [ "$FIX_OWNERSHIP" != "" ]; then
	chown -R apache:apache /app
fi

# display logs
tail -F /var/log/apache2/*log &


echo "[i] Starting daemon..."
# run apache httpd daemon
httpd -D FOREGROUND

