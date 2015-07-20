#!/bin/bash


apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade

#Add dependencies
apt-get remove python-pypcap && apt-get -y install cifs-utils libssh2-1 libssh2-1-dev libgnutls-dev python-libpcap conntrack mingw32 terminator shutter screen tmux python-support libdumbnet1 python-ipy python-glade2
cp -R /usr/share/doc/python-impacket-doc/examples/smbrelayx /toolslinux/exploits/impacket/impacket/

#########################################
# custom bash search
echo "## arrow up" >> ~/.inputrc
echo "\"\\e[A\":history-search-backward" >> ~/.inputrc
echo "## arrow down" >> ~/.inputrc
echo "\"\\e[B\":history-search-forward" >> ~/.inputrc
#########################################

./github_clone.sh

#########################################
# Loki Setup
apt-get remove python-libpcap

mkdir -p ~/Loki
cd ~/Loki
wget https://www.ernw.de/wp-content/uploads/pylibpcap_0.6.2-1_i386.deb
wget http://snapshot.debian.org/archive/debian/20110406T213352Z/pool/main/o/openssl098/libssl0.9.8_0.9.8o-7_i386.deb
wget http://ftp.us.debian.org/debian/pool/main/p/python-dpkt/python-dpkt_1.6+svn54-1_all.deb
wget http://mirrors.kernel.org/ubuntu/pool/universe/libd/libdumbnet/python-dumbnet_1.12-3.1_i386.deb
wget http://launchpadlibrarian.net/103839793/python-central_0.6.17ubuntu2_all.deb
wget https://www.ernw.de/wp-content/uploads/loki_0.2.7-1_i386.deb
wget https://www.ernw.de/wp-content/uploads/pylibpcap_0.6.2-1_amd64.deb
wget http://snapshot.debian.org/archive/debian/20110406T213352Z/pool/main/o/openssl098/libssl0.9.8_0.9.8o-7_amd64.deb
wget http://mirrors.kernel.org/ubuntu/pool/universe/libd/libdumbnet/python-dumbnet_1.12-3.1_amd64.deb
wget https://www.ernw.de/wp-content/uploads/loki_0.2.7-1_amd64.deb

dpkg -i python-central_0.6.17ubuntu2_all.deb

# x86
dpkg -i libssl0.9.8_0.9.8o-7_i386.deb python-dpkt_1.6+svn54-1_all.deb python-dumbnet_1.12-3.1_i386.deb pylibpcap_0.6.2-1_i386.deb
dpkg –i loki_0.2.7-1_i386.deb

# x64
dpkg -i libssl0.9.8_0.9.8o-7_amd64.deb python-dpkt_1.6+svn54-1_all.deb python-dumbnet_1.12-3.1_amd64.deb pylibpcap_0.6.2-1_amd64.deb
dpkg -i loki_0.2.7-1_amd64.deb
#########################################