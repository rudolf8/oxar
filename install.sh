rm -rf /etc/sysconfig/selinux
echo "SELINUX=disabled" >> /etc/sysconfig/selinux
setenforce 0

cd /tmp/autopex
. build.sh
