# /bin/bash

dir=$(pwd)

# Check 2 arguments are given #
if [[ $# -lt 1 ]] || [[ $1 == --help ]] || [[ $1 != -*[dps]* ]]; then
	echo "Usage : mail.sh [OPTION]"
	echo "  mail.sh -dps"
	echo "========================================"
	echo "  OPTIONS"
	echo "   -d	:Docker Install and Config"
	echo "   -p	:Phishing Frenzy Setup"
	echo "   -s	:iRedMail SMTP Setup"
	echo "========================================"
	exit
fi

option=$1

if [[ $option == *[d]* ]]; then
	sudo apt-get update && sudo apt-get -y upgrade
	sudo apt-get -y install openssh-server screen terminator curl git build-essential tcl linux-image-extra-$(uname -r) linux-image-extra-virtual
	sudo apt-get -y install apt-transport-https ca-certificates
	curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -
	sudo add-apt-repository \
	       "deb https://apt.dockerproject.org/repo/ \
	       ubuntu-$(lsb_release -cs) \
	       main"

	sudo apt-get update
	sudo apt-get -y install docker-engine
	sudo service docker start

	# configure Docker user group permissions
	sudo groupadd docker
	sudo gpasswd -a ${USER} docker
	sudo service docker restart

	# set Docker to auto-launch on startup
	sudo systemctl enable docker


	cat > /usr/bin/docker-pid <<'EOF'
#!/bin/sh
exec docker inspect --format '{{ .State.Pid }}' "$@"
EOF
	chmod +x /usr/bin/docker-pid

	cat > /usr/bin/docker-ip <<'EOF'
#!/bin/sh
exec docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
EOF
	chmod +x /usr/bin/docker-ip

	sudo apt-get install -y docker-compose
fi
# reboot / post docker install

if [[ $option == *[p]* ]]; then
	# PHISHING FRENZY INSTALL
	sudo sh -c "echo 127.0.0.1       phishingfrenzy.local >> /etc/hosts"
	# TAS - NOT WORKING
	#docker build /home/user/phishing-frenzy-docker

	# From Docker repo
	docker pull b00stfr3ak/ubuntu-phishingfrenzy
	# From Github
	# docker build -t="b00stfr3ak/ubuntu-phishingfrenzy"  github.com/b00stfr3ak/ubuntu-phishingfrenzy
	# github.com/jbarcia/ubuntu-phishingfrenzy

	docker run --name phishingfrenzy -d --restart=always -p 80:80 b00stfr3ak/ubuntu-phishingfrenzy
fi

if [[ $option == *[s]* ]]; then
	# iREDMAIL SMTP INSTALL
	docker build -t="zokeber/iredmail:latest" github.com/zokeber/docker-iredmail
	# github.com/jbarcia/docker-iredmail

	echo -n "Enter the FQDN [ENTER]: "
	read domain
	
	docker create --privileged -it --restart=always -p 80:80 -p 443:443 -p 25:25 -p 587:587 -p 110:110 -p 143:143 -p 993:993 -p 995:995 -h $domain --name iredmail zokeber/iredmail
	docker start iredmail

	# docker run --privileged -it --restart=always -p 80:80 -p 443:443 -p 25:25 -p 587:587 -p 110:110 -p 143:143 -p 993:993 -p 995:995 -h your_domain.com --name iredmail zokeber/iredmai

	# install docker-enter
	docker run -v /usr/local/bin:/target jpetazzo/nsenter
	
	echo "access the shell of the running container iredmail: docker-enter iredmail"
	echo "Customize the configuration of iRedMail: cd /iRedMail-0.9.0/ ; chmod +x iRedMail.sh ; ./iRedMail.sh"
fi

