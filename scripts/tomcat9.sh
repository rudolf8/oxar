#!/bin/bash
# UNDER CONSTRUCTION

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

#Reload systemd just in case anything is cached with this service name
systemctl daemon-reload
#Stop and dissable tomcat from sytem startup
systemctl stop ${TOMCAT_SERVICE_NAME}
systemctl disable ${TOMCAT_SERVICE_NAME}

#Add a user into tomcat-users.xml (/etc/tomcat/tomcat-user.xml) as defined in config.properties
perl -i -p -e "s/<tomcat-users>/<tomcat-users>\n  <\!-- Auto generated content by http\:\/\/www.github.com\/OraOpenSource\/oraclexe-apex install scripts -->\n  <role rolename=\"manager-gui\"\/>\n  <user username=\"${OOS_TOMCAT_USERNAME}\" password=\"${OOS_TOMCAT_PASSWORD}\" roles=\"manager-gui\"\/>\n  <\!-- End auto-generated content -->/g" ${CATALINA_HOME}/conf/tomcat-users.xml

# Copy the configuration template over
cp -f ${CATALINA_HOME}/conf/server.xml ${CATALINA_HOME}/conf/server_original.xml
# See #150
\cp -f $OOS_SOURCE_DIR/tomcat/server.xml ${CATALINA_HOME}/conf/server.xml

# Set the preferred port
sed -i "s/OOS_TOMCAT_SERVER_PORT/${OOS_TOMCAT_PORT}/" ${CATALINA_HOME}/conf/server.xml

systemctl enable ${TOMCAT_OXAR_SERVICE_NAME}
systemctl start ${TOMCAT_OXAR_SERVICE_NAME}

