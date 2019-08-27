#Ensure user is currently root
if [ "$(whoami)" != "root" ]; then
  sudo -i
fi

cd /tmp

#Install Git
if [ -n "$(command -v yum)" ]; then
  #RHEL type OS
  yum install git -y
else
  #Debian type OS
  apt-get install git-core
fi

git clone https://github.com/nl2019/autopex.git
cd autopex
. build.sh
cd
