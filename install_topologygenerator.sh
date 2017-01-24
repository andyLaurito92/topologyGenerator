#!/bin/bah

WGET_INSTALLED=$(which wget)
if [ -z "${WGET_INSTALLED// }" ]
 then
 	apt-get install wget
fi

wget -L https://github.com/andyLaurito92/topologygenerator/archive/master.tar.gz ; mkdir -p topologygenerator && tar xf master.tar.gz -C topologygenerator --strip-components=1
rm master.tar.gz
rm master.tar.gz.1

cd topologygenerator

#Add directory to $PATH
TOPOLOGYGENERATOR_DIRECTORY=$(pwd)
echo "export PATH=\"$PATH:$TOPOLOGYGENERATOR_DIRECTORY/lib\" # Adding Topologygenerator's directory to your PATH variable" >> ~/.bashrc

source ~/.bashrc
