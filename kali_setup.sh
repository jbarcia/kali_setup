#!/bin/bash
# Kali Build Script

apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade

#Add dependencies
apt-get remove python-pypcap && apt-get -y install cifs-utils libssh2-1 libssh2-1-dev libgnutls-dev python-libpcap conntrack mingw32 terminator shutter screen tmux python-support libdumbnet1 python-ipy python-glade2 flashplugin-nonfree unrar unace rar unrar p7zip zip unzip p7zip-full p7zip-rar file-roller filezilla filezilla-common golang remmina 
update-flashplugin-nonfree --install

mkdir /mnt/share

# cp -R /usr/share/doc/python-impacket-doc/examples/smbrelayx /toolslinux/exploits/impacket/impacket/
gem install nmap-parser

#########################################
# custom bash search
echo "## arrow up" >> ~/.inputrc
echo "\"\\e[A\":history-search-backward" >> ~/.inputrc
echo "## arrow down" >> ~/.inputrc
echo "\"\\e[B\":history-search-forward" >> ~/.inputrc
#########################################

#########################################
# Loki Setup
apt-get -y remove python-libpcap

cd loki_debs

dpkg -i python-central_0.6.17ubuntu2_all.deb

# x86
dpkg -i libssl0.9.8_0.9.8o-7_i386.deb python-dpkt_1.6+svn54-1_all.deb python-dumbnet_1.12-3.1_i386.deb pylibpcap_0.6.2-1_i386.deb
dpkg –i loki_0.2.7-1_i386.deb

# x64
dpkg -i libssl0.9.8_0.9.8o-7_amd64.deb python-dpkt_1.6+svn54-1_all.deb python-dumbnet_1.12-3.1_amd64.deb pylibpcap_0.6.2-1_amd64.deb libcap-dev_2.22-1.2_amd64.deb libpcap0.8-dev_1.3.0-1_amd64.deb
dpkg -i loki_0.2.7-1_amd64.deb
#########################################

cd ..
./github_clone.sh

#########################################
# Crowe Medusa v2.2_rc2
cp /toolslinux/passwords/medusa/Crowe_Medusa-2.2_rc2.zip /tmp/
cd /tmp
unzip Crowe_Medusa-2.2_rc2.zip
cd root/medusa-2.2_rc2/
./configure && make && make install
#########################################

#########################################
# Shareenum
dpkg -i /toolslinux/recon/shareenum/shareenum_2.0_amd64.deb
#########################################

#########################################
# NTDS_EXTRACT
mkdir ~/NTDS_EXTRACT
cd ~/NTDS_EXTRACT
cp /toolsv3/Assessment/_Post-Exploitation/VSS/libesedb-alpha-20120102.tar.gz ~/NTDS_EXTRACT/
cp /toolsv3/Assessment/_Post-Exploitation/VSS/ntdsxtract_v1_0.zip ~/NTDS_EXTRACT/
cp /toolsv3/Assessment/_Post-Exploitation/VSS/dshashes.py ~/NTDS_EXTRACT/
tar zxvf libesedb-alpha-20120102.tar.gz
unzip ntdsxtract_v1_0.zip
cp dshashes.py NTDSXtract\ 1.0/dshashes.py

cd libesedb-20120102
chmod +x configure
./configure && make
#########################################

#########################################
# John the Ripper Community Enhanced Version
cd /tmp
wget http://www.openwall.com/john/j/john-1.8.0-jumbo-1.tar.gz
tar xzvf john-1.8.0-jumbo-1.tar.gz
cd john-1.8.0-jumbo-1/src
./configure
make clean && make -s
make && make install
mv /usr/sbin/john /usr/sbin/john.bak
cd ../run
cp john /usr/sbin/john

# Optional
john --test
#########################################

cd ~