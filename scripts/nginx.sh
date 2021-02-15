#!/bin/bash

if [ -n "$(command -v yum)" ]; then
  echo; echo \* Installing Ngix with yum \*
  
  yum install nginx -y

elif [ -n "$(command -v apt-get)" ]; then
  echo; echo \* Installing Ngix with apt-get \*
 
 apt-get install nginx -y
 
else
  echo; echo \* No known package manager found \*
fi

systemctl start nginx
systemctl enable nginx

# Generate an unsigned certificate

mkdir /etc/ssl/private
chmod 700 /etc/ssl/private
cd /etc/ssl/private

openssl req -newkey rsa:2048 -nodes -keyout /etc/ssl/private/nginx-selfsigned.key \
  -x509 -days 365 -out /etc/ssl/certs/nginx-selfsigned.crt \
  -subj "/C=DE/ST=Bavaria/L=Munich/O=Dis/CN=localhost"

# Modify Node4ORDS Config
cd /opt/node4ords
sed -i 's/CHANGEME_HTTPS_KEYPATH/\/var\/www\/certs\/localhost.key/g' config.js
sed -i 's/CHANGEME_HTTPS_CERTPATH/\/var\/www\/certs\/localhost.crt/g' config.js
sed -i 's/config.web.https.enabled = false;/config.web.https.enabled = true;/g' config.js

#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
