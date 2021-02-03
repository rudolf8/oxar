#!/bin/bash

# Create user and home directory
useradd -m -U -d /opt/tomcat -s /bin/false tomcat

cd $OOS_SOURCE_DIR/tmp
${OOS_UTILS_DIR}/download.sh $OOS_TOMCAT_FILE_URL

unzip $OOS_TOMCAT_ZIP_FILENAME

#Make dir if doesn't exist
rm -rf /opt/tomcat

cp -r apache* /opt/tomcat

ln -s /opt/tomcat/$OOS_TOMCAT_FILENAME /opt/tomcat/latest

# Make tomcat dir owner
chown -R tomcat: /opt/tomcat

sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'

. /opt/tomcat/latest/tomcat.conf
TOMCAT_USER=tomcat
TOMCAT_SERVICE_NAME=tomcat


cp /etc/systemd/system/tomcat.service /etc/systemd/system/${TOMCAT_OXAR_SERVICE_NAME}.service
#cp /usr/lib/systemd/system/${TOMCAT_SERVICE_NAME}.service /usr/lib/systemd/system/${TOMCAT_OXAR_SERVICE_NAME}.service

sed -i 's/After=syslog.target network.target/After=syslog.target network.target oracle-xe.service/' /etc/systemd/system/${TOMCAT_OXAR_SERVICE_NAME}.service
#sed -i 's/After=syslog.target network.target/After=syslog.target network.target oracle-xe.service/' /usr/lib/systemd/system/${TOMCAT_OXAR_SERVICE_NAME}.service

#and the provides name to match script name
sed -i 's/Provides:          tomcat9/Provides:          tomcat@oxar/' /etc/init.d/${TOMCAT_OXAR_SERVICE_NAME}

