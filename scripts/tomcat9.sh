#!/bin/bash
### Install Tomcat 9 on Ubuntu, Debian, CentOS, OpenSUSE 64Bits

# Check if user has root privileges
if [[ $EUID -ne 0 ]]; then
echo "You must run the script as root or using sudo"
   exit 1
fi

rm -rf /usr/local/tomcat
groupadd tomcat && useradd -M -s /bin/nologin -g tomcat -d /usr/local/tomcat tomcat

cd $OOS_SOURCE_DIR/tmp
${OOS_UTILS_DIR}/download.sh $OOS_TOMCAT_FILE_URL

unzip $OOS_TOMCAT_ZIP_FILENAME

cd apache-tomcat* 
cp -r * /usr/local/tomcat

ln -s /usr/local/tomcat /usr/local/tomcat/latest
 
#echo 'JAVA_HOME=/usr/local/java
#export JAVA_HOME
#PATH=$PATH:$JAVA_HOME/bin
#export PATH' >> /etc/profile
 
#source /etc/profile
#java -version

# Set tomcat environmental variables such as CATALINA_HOME
. /etc/tomcat/tomcat.conf
TOMCAT_USER=tomcat
TOMCAT_SERVICE_NAME=tomcat

    
 #Modifications to tomcat service file.
 cp $OOS_SOURCE_DIR/tomcat/tomcat.service /etc/systemd/system/tomcat/${TOMCAT_OXAR_SERVICE_NAME}.service
 
 #Add `oracle-xe` to the After clause to encourage waiting for the db to be up and running
 sed -i 's/After=syslog.target network.target/After=syslog.target network.target oracle-xe.service/' /etc/systemd/system/tomcat/${TOMCAT_OXAR_SERVICE_NAME}.service

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
cp -f $OOS_SOURCE_DIR/tomcat/server.xml ${CATALINA_HOME}/conf/server.xml

# Set the preferred port
sed -i "s/OOS_TOMCAT_SERVER_PORT/${OOS_TOMCAT_PORT}/" ${CATALINA_HOME}/conf/server.xml

systemctl daemon-reload
systemctl start ${TOMCAT_OXAR_SERVICE_NAME}
systemctl enable ${TOMCAT_OXAR_SERVICE_NAME}

## Open in web browser:
## http://server_IP_address:8080
