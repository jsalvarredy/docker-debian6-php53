#!/bin/bash
set -e

/etc/init.d/rsyslog start

if [ ! -z "$MAIL_DOMAIN" ]; then
    postconf -e myhostname=$MAIL_DOMAIN
else
    postconf -e myhostname=example.com
fi

postconf -e mydestination=localhost

/etc/init.d/postfix start

source /etc/apache2/envvars

# Map www-data uid to specified USER_ID. If no specified, uid 1000 will be used
if [ ! -z "$USER_ID" ]; then
  usermod -u $USER_ID $APACHE_RUN_USER
else
  usermod -u 1000 $APACHE_RUN_USER
fi


echo ' \
<Directory />
        Options FollowSymLinks
        AllowOverride None
</Directory>

<Directory /var/www/>
        AllowOverride All
</Directory>

DocumentRoot /var/www' >> /etc/apache2/apache2.conf

#Para que se vean en los logs la IP origen
if [ ! -z "$IP_NGINXPROXY" ]; then
	sed -i "s/127.0.0.1/$IP_NGINXPROXY/g" /etc/apache2/mods-available/rpaf.conf
else
	sed -i "s/127.0.0.1/172.17.0.1/g" /etc/apache2/mods-available/rpaf.conf
fi


a2enmod rewrite
a2dissite default
apache2 -DFOREGROUND
