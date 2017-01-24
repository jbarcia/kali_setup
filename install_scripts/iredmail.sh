# /bin/bash

dir=$(pwd)

# Check 2 arguments are given #
if [[ $1 == --help ]]; then
	echo "Usage : iredmail.sh [OPTION]"
	echo "  iredmail.sh -f file.txt"
	echo "========================================"
	echo "  OPTIONS"
	echo "   -f	:Hostnames from File"
	echo "========================================"
	exit
fi

# Check the given file is exist #
if [ ! -f $2 ]
then
        echo "Filename \"$2\" doesn't exist"
        exit
fi

totalk=$(awk '/^MemTotal:/{print $2}' /proc/meminfo)
if [[ $totalk < 3955128 ]]; then
	echo -n "Recommended 4GB of memory required"
	exit
fi

TOTALSWAP=`free -m | tail -1| awk '{print $2}'`
if [[ $TOTALSWAP < 4048 ]]; then
	echo -n "Recommended 4GB of SWAP required"
	exit
fi


option=$1
filename=$2



if [[ $option != *[f]* ]]; then
	echo -n "Enter the FQDN [ENTER]: "
	read domain
	host=$(echo $domain | cut -f 1 -d ".")
	sudo hostname $host
	sudo sh -c "echo 127.0.0.1       "$domain" "$host" localhost | cat - /etc/hosts > temp && mv temp /etc/hosts"
	sudo sh -c "echo "$domain"|cut -d. -f1 > /etc/hostname" 
fi

if [[ $option == *[f]* ]]; then
	while read p; do
		sudo sh -c "echo 127.0.0.1       "$p" >> hosts"
	done < $filename
fi

sudo apt-get update && sudo apt-get -q -y upgrade
sudo apt-get -q -y install zip unzip tmux openssh-server screen terminator curl wget git build-essential tcl bzip2 python-letsencrypt-apache 

wget https://bitbucket.org/zhb/iredmail/downloads/iRedMail-0.9.6.tar.bz2
tar xjf iRedMail-0.9.6.tar.bz2
cd iRedMail-0.9.6
chmod +x iRedMail.sh
sudo bash iRedMail.sh

echo ****************************************************************************
cat iRedMail.tips
echo ****************************************************************************

letsencrypt --apache
#letsencrypt certonly
# cp server.crt /etc/ssl/certs/
# cp server.ca-bundle /etc/ssl/certs/
# cp server.key /etc/ssl/private/
# 
# postconf -e smtpd_tls_cert_file='/etc/pki/tls/certs/server.crt'
# postconf -e smtpd_tls_key_file='/etc/pki/tls/private/server.key'
# postconf -e smtpd_tls_CAfile='/etc/pki/tls/certs/server.ca-bundle'
# 
