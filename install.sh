rm -rf /etc/sysconfig/selinux
echo "SELINUX=disabled" >> /etc/sysconfig/selinux
satenforce 0

cd /tmp/autopex
. build.sh
