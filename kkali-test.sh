#!/bin/bash
#-Metadata----------------------------------------------------#
#  Filename: kali.sh                     (Update: 2016-10-08) #
#-Info--------------------------------------------------------#
#  Personal post-install script for Kali Linux 2.0.           #
#-Author(s)---------------------------------------------------#
#  jbarcia / based off of g0tmilk                             #
#-Operating System--------------------------------------------#
#  Designed for: Kali Linux 2.0.0 [x64] (VM - VMware)         #
#     Tested on: Kali Linux 2.0.0 [x64/x84/full/light/mini/vm]#
#-Licence-----------------------------------------------------#
#  MIT License ~ http://opensource.org/licenses/MIT           #
#-Notes-------------------------------------------------------#
#  Run as root, just after a fresh/clean install of Kali 2.0. #
#  Kali v1.0 see ~ https://g0tmi1k/os-scripts/master/kali1.sh #
#                             ---                             #
#  By default it will set the time zone & keyboard to US/NY.  #
#                             ---                             #
#  Command line arguments:                                    #
#    --burp    = Automates configuring Burp Proxy (Free)      #
#    --hold    = Disable updating certain packages (e.g. msf) #
#    --openvas = Installs & configures OpenVAS vuln scanner   #
#    --osx     = Configures Apple keyboard layout             #
#                                                             #
#    e.g. # bash kali.sh --osx --burp --openvas               #
#                             ---                             #
#  Incomplete/buggy/hidden stuff - search for '***'.          #
#                             ---                             #
#             ** This script is meant for _ME_. **            #
#         ** EDIT this to meet _YOUR_ requirements! **        #
#-------------------------------------------------------------#


#-Defaults-------------------------------------------------------------#

##### Optional steps
freezeDEB=false             # Disable updating certain packages (e.g. Metasploit)            [ --hold ]
burpFree=false              # Disable configuring Burp Proxy Free (for Burp Pro users...)    [ --burp ]
openVAS=false               # Install & configure OpenVAS (not everyone wants it...)         [ --openvas ]

##### Github directory
gitdir=/root/github
mkdir -p $gitdir

##### (Optional) Enable debug mode?
#set -x

##### Get Kernel Version
proc=0
arm=0
if [ "$(uname -m)" == "x86_64" ]; then 
  proc=64
#  echo "64 bit"
elif [ "$(uname -m)" == "i386" ]; then 
  proc=32
#  echo "32 bit"
elif [[ "$(uname -m)" == *"arm"* ]]; then 
  arm=1
#  echo "ARM"
fi

##### Get Kali Version
vers=0
if [ "$(cat /etc/issue | cut -d/ -f2 | cut -d\\ -f1)" == "Linux Rolling " ]; then
  vers=rolling 
elif [ "$(cat /etc/issue | cut -d. -f1)" == "Kali GNU/Linux 2" ]; then 
  vers=kali2
elif [ "$(cat /etc/issue | cut -d. -f1)" == "Kali GNU/Linux 1" ]; then 
  vers=kali1
fi

##### (Cosmetic) Colour output
RED="\033[01;31m"      # Issues/Errors
GREEN="\033[01;32m"    # Success
YELLOW="\033[01;33m"   # Warnings/Information
BLUE="\033[01;34m"     # Heading
BOLD="\033[01;01m"     # Highlight
RESET="\033[00m"       # Normal


#-Arguments------------------------------------------------------------#


##### Read command line arguments
for x in $( tr '[:upper:]' '[:lower:]' <<< "$@" ); do
  if [[ "${x}" == "--osx" || "${x}" == "--apple" ]]; then
    keyboardApple=true
  elif [ "${x}" == "--hold" ]; then
    freezeDEB=true
  elif [ "${x}" == "--burp" ]; then
    burpFree=true
  elif [ "${x}" == "--openvas" ]; then
    openVAS=true
  else
    echo -e ' '${RED}'[!]'${RESET}" Unknown option: ${RED}${x}${RESET}" 1>&2
    exit 1
  fi
done


#-Start----------------------------------------------------------------#


##### Check if we are running as root - else this script will fail (hard!)
if [[ ${EUID} -ne 0 ]]; then
  echo -e ' '${RED}'[!]'${RESET}" This script must be ${RED}run as root${RESET}. Quitting..." 1>&2
  exit 1
else
  echo -e " ${BLUE}[*]${RESET} ${BOLD}Kali Linux post-install script${RESET}"
fi

##### Install Github repos
git config --global user.name jbarcia;git config --global user.email jbarcia.spam@gmail.com
read -r -p "Install Github repos? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    chmod +x github_clone.sh
    ./github_clone.sh
fi

################################ Install Work Specific Tools ################################
##### Install John the Ripper Community Enhanced Version
apt-get -y -qq install curl libssl-dev openssl || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
dpkg --configure -a
#if [ $arm == 0 ]; then 
#  curl --progress -k -L -f "http://www.openwall.com/john/j/john-1.8.0-jumbo-1.tar.gz" > /tmp/john-1.8.0-jumbo-1.tar.gz || echo -e ' '${RED}'[!]'${RESET}" Issue downloading JTR Community" 1>&2   #***!!! hardcoded version! Need to manually check for updates
#  cd /tmp
#  tar xzvf john-1.8.0-jumbo-1.tar.gz
#  cd john-1.8.0-jumbo-1/src
#  ./configure
#  make clean && make -s
#  make && make install
#  mv /usr/sbin/john /usr/sbin/john.bak
#  cd ../run
#  cp john /usr/sbin/john
# 
#  # Optional
#  #john --test
#fi

#apt-get --reinstall install john

##### Install Work Specific Scripts
# Github download
read -r -p "SSH Key for Github repos installed? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    cd $gitdir
    git clone git@github.com:jbarcia/Crowe-Scripts.git
    mkdir /toolslinux
    ln -s /root/github/Crowe-Scripts/pen-tools/Linux/* /toolslinux/
    ln -s /root/github/Crowe-Scripts/pen-tools /
    # Crowe Medusa v2.2_rc2
    #if [ $arm == 0 ]; then 
    #  cp /toolslinux/passwords/medusa/Crowe_Medusa-2.2_rc2.zip /tmp/
    #  cd /tmp
    #  unzip Crowe_Medusa-2.2_rc2.zip
    #  cd root/medusa-2.2_rc2/
    #  ./configure && make && make install
    #fi
    # NTDS_EXTRACT
    if [ ! -d "~/NTDS_EXTRACT" ]; then
      mkdir ~/NTDS_EXTRACT
      cd ~/NTDS_EXTRACT
      cp /pen-tools/Assessment/_Post-Exploitation/VSS/libesedb-alpha-20120102.tar.gz ~/NTDS_EXTRACT/
      cp /pen-tools/Assessment/_Post-Exploitation/VSS/ntdsxtract_v1_0.zip ~/NTDS_EXTRACT/
      cp /pen-tools/Assessment/_Post-Exploitation/VSS/dshashes.py ~/NTDS_EXTRACT/
      tar zxvf libesedb-alpha-20120102.tar.gz
      unzip ntdsxtract_v1_0.zip
      cp dshashes.py NTDSXtract\ 1.0/dshashes.py
      cd libesedb-20120102
      chmod +x configure
      ./configure && make
    fi
fi


###### Loki Setup
read -r -p "Install Loki? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
  apt-get -y -qq install curl || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}
  if [ $arm == 0 ]; then 
    apt-get -y remove python-libpcap
    curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/python-central_0.6.17ubuntu2_all.deb" > /tmp/python-central_0.6.17ubuntu2_all.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading python-central_0.6.17ubuntu2_all.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
    cd /tmp
    dpkg -i python-central_0.6.17ubuntu2_all.deb
  fi
  ## x86
  if [ $proc == 32 ]; then 
    curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/libssl0.9.8_0.9.8o-7_i386.deb" > /tmp/libssl0.9.8_0.9.8o-7_i386.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading libssl0.9.8_0.9.8o-7_i386.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
    curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/python-dpkt_1.6+svn54-1_all.deb" > /tmp/python-dpkt_1.6+svn54-1_all.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading python-dpkt_1.6+svn54-1_all.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
    curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/python-dumbnet_1.12-3.1_i386.deb" > /tmp/python-dumbnet_1.12-3.1_i386.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading python-dumbnet_1.12-3.1_i386.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
    curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/pylibpcap_0.6.2-1_i386.deb" > /tmp/pylibpcap_0.6.2-1_i386.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading pylibpcap_0.6.2-1_i386.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
    curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/loki_0.2.7-1_i386.deb" > /tmp/loki_0.2.7-1_i386.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading loki_0.2.7-1_i386.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
    dpkg -i libssl0.9.8_0.9.8o-7_i386.deb python-dpkt_1.6+svn54-1_all.deb python-dumbnet_1.12-3.1_i386.deb pylibpcap_0.6.2-1_i386.deb
    dpkg –i loki_0.2.7-1_i386.deb
  ## x64
  elif [ $proc == 64 ]; then
    curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/libssl0.9.8_0.9.8o-7_amd64.deb" > /tmp/libssl0.9.8_0.9.8o-7_amd64.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading libssl0.9.8_0.9.8o-7_amd64.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
    curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/python-dpkt_1.6+svn54-1_all.deb" > /tmp/python-dpkt_1.6+svn54-1_all.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading python-dpkt_1.6+svn54-1_all.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
    curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/python-dumbnet_1.12-3.1_amd64.deb" > /tmp/python-dumbnet_1.12-3.1_amd64.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading python-dumbnet_1.12-3.1_amd64.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
    curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/pylibpcap_0.6.2-1_amd64.deb" > /tmp/pylibpcap_0.6.2-1_amd64.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading pylibpcap_0.6.2-1_amd64.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
    curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/libcap-dev_2.22-1.2_amd64.deb" > /tmp/libcap-dev_2.22-1.2_amd64.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading libcap-dev_2.22-1.2_amd64.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
    curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/libpcap0.8-dev_1.3.0-1_amd64.deb" > /tmp/libpcap0.8-dev_1.3.0-1_amd64.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading libpcap0.8-dev_1.3.0-1_amd64.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates
    curl --progress -k -L -f "https://github.com/jbarcia/kali_setup/blob/master/loki_debs/loki_0.2.7-1_amd64.deb" > /tmp/loki_0.2.7-1_amd64.deb || echo -e ' '${RED}'[!]'${RESET}" Issue downloading loki_0.2.7-1_amd64.deb" 1>&2   #***!!! hardcoded version! Need to manually check for updates

    dpkg -i libssl0.9.8_0.9.8o-7_amd64.deb python-dpkt_1.6+svn54-1_all.deb python-dumbnet_1.12-3.1_amd64.deb pylibpcap_0.6.2-1_amd64.deb libcap-dev_2.22-1.2_amd64.deb libpcap0.8-dev_1.3.0-1_amd64.deb
    dpkg -i loki_0.2.7-1_amd64.deb
  fi
fi

##### Install 32 bit libraries for wmic.py
#if [ $proc == 64 ]; then 
#  dpkg --add-architecture i386
#  apt-get update
#  apt-get install ia32-libs
#  cp pth-wmi/kaliwmis-32 /usr/sbin/kaliwmis-32
#fi

#############################################################################################


#### Setup Anonymous SMB
smbpasswd -an nobody
mkdir -p /mnt/smb

sed -i 's/\[Global\]/\[Global\] \n guest account = nobody \n map to guest = bad user/I' /etc/samba/smb.conf

cat <<EOF >> /etc/samba/smb.conf

[AnonShare]
 comment = Guest access share
 path = /mnt/smb
 browseable = yes
 writable = yes
 read only = no
 guest ok = yes

EOF

chmod -R a+rwx /mnt/smb
service smbd restart
service nmbd restart

#### Desktop Network File
cat <<EOF > /etc/profile.d/screensaver_off.sh

#!/bin/bash
sleep 2; xset s off
sleep 2; xset s noblank
sleep 2; xset -dpms
EOF

chmod +x /etc/profile.d/screensaver_off.sh

#### Desktop Network File
cat <<EOF > /root/Desktop/Network.txt
----------------------------------------------------------------------------
macchanger -l|grep -i Cisco
macchanger -l|grep -i VMWare
----------------------------------------------------------------------------
DHCP
ifconfig <interface> down
macchanger --mac=XX:XX:XX:XX:XX:XX <interface>
ifconfig <interface> up
dhclient <interface>
----------------------------------------------------------------------------
STATIC
ifconfig <interface> down
macchanger --mac=XX:XX:XX:XX:XX:XX <interface>
ifconfig <interface> <IP_Address> netmask 255.255.255.0 broadcast <IP_Address>.255
echo "nameserver <DNS_SERVER>" >> /etc/resolv.conf
route add default gw <GATEWAY_Address>
ifconfig <interface> up
----------------------------------------------------------------------------
CONKY
ps aux | grep conky
kill -9 1092
conky &
----------------------------------------------------------------------------
WEB CONTENT
/usr/share/mana-toolkit/www/portal/
----------------------------------------------------------------------------
GITHUB
git clone 'http://.git'
git clone 'git@github.com:<Username>/<Project>.git'

git remote set-url origin git@github.com:<Username>/<Project>.git

git commit -a -m 'COMMENT'
git push

git pull

git stash
git reset --hard HEAD
----------------------------------------------------------------------------
DOCKER
docker run -d --name <NAME> -p <IP ADDRESS>:80:80
docker stop <DOCKER CONTAINER>
docker restart <DOCKER CONTAINER>
docker rm <DOCKER CONTAINER>

docker-pid <DOCKER CONTAINER>
docker-ip <DOCKER CONTAINER>

MATTERMOST CHAT
docker pull mattermost/mattermost-preview
docker run --name mattermost -d --restart=always --publish <IP ADDRESS>:8065:8065 mattermost/mattermost-preview
http://localhost:8065/


Bloodhound
docker pull neo4j
docker run --name neo4j -d --restart=always -p 127.0.0.1:7474:7474 -p 127.0.0.1:7687:7687 neo4j
~/BloodHound-linux-x64/BloodHound


MWR AD Control Mapping
cd /root/ad-control-mapping-master
docker-compose build
docker-compose up -d
docker-compose exec app rake db:create db:migrate assets:precompile
docker run adcontrolmappingmaster_app
http://127.0.0.1:3000
----------------------------------------------------------------------------
EOF

updatedb

echo -e '\n'${YELLOW}''${BOLD}'Configure Shutter Screenshot directory'${RESET}'\n\a'
echo -e '\n'${YELLOW}''${BOLD}'Configure PrntScrn Keyboard Shortcuts -> System-tools-->preferences-->System Setting--> Keyboard'${RESET}'\n\a'
echo -e '\n'${BLUE}''${BOLD}'           --> shutter -f -C -e      Shutter Full Screen'${RESET}'\n\a'
echo -e '\n'${BLUE}''${BOLD}'           --> shutter -a -C -e      Shutter Active Window'${RESET}'\n\a'
echo -e '\n'${YELLOW}''${BOLD}'Disable Network Connections'${RESET}'\n\a'
echo -e '\n'${BLUE}''${BOLD}'           --> Edit Connections --> General --> Auto Connect to this network'${RESET}'\n\a'
echo -e '\n'${YELLOW}''${BOLD}'Check NMAP Aliases'${RESET}'\n\a'
echo -e '\n'${BLUE}''${BOLD}'           --> .bash_aliases'${RESET}'\n\a'.bash_aliases
echo -e '\n'${BLUE}'[*]'${RESET}' '${BOLD}'Done!'${RESET}'\n\a'
exit 0
