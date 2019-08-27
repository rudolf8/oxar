rm -rf /etc/sysconfig/selinux
echo 'SELINUX=disabled' >> /etc/sysconfig/selinux
setenforce 0

. autopex/build.sh
