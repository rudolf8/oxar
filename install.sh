rm -rf /etc/sysconfig/selinux
echo 'SELINUX=disabled' >> /etc/sysconfig/selinux
setenforce 0

. oxar/build.sh
