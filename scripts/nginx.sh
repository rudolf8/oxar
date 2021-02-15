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

# Create SSL certificate
mkdir /etc/ssl/private
chmod 700 /etc/ssl/private

#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
