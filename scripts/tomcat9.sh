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
 
echo 'JAVA_HOME=/usr/local/java
export JAVA_HOME
PATH=$PATH:$JAVA_HOME/bin
export PATH' >> /etc/profile
 
source /etc/profile
java -version

echo '# Systemd unit file for tomcat
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target
[Service]
Type=forking
Environment=JAVA_HOME=/usr/local/java
Environment=CATALINA_PID=/usr/local/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINA_BASE=/usr/local/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
ExecStart=/usr/local/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID
User=tomcat
Group=tomcat
[Install]
WantedBy=multi-user.target' > /etc/systemd/system/${TOMCAT_OXAR_SERVICE_NAME}
 
 
systemctl daemon-reload
systemctl start ${TOMCAT_OXAR_SERVICE_NAME}
systemctl enable ${TOMCAT_OXAR_SERVICE_NAME}

## Open in web browser:
## http://server_IP_address:8080
