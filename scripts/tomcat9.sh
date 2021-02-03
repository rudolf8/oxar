#!/bin/bash

useradd -m -U -d /opt/tomcat -s /bin/false tomcat

cd $OOS_SOURCE_DIR/tmp
${OOS_UTILS_DIR}/download.sh $OOS_TOMCAT_FILE_URL

tar -xf $OOS_TOMCAT_FILE_URL

#Make dir if doesn't exist
rm -rf /opt/tomcat
cp -r apache* /opt/tomcat

ln -s /opt/tomcat/$OOS_TOMCAT_FILENAME /opt/tomcat/latest

# Make tomcat dir owner
chown -R tomcat: /opt/tomcat


