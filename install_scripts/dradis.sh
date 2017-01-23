# /bin/bash

dir=$(pwd)

# Check 2 arguments are given #
if [[ $# -lt 1 ]] || [[ $1 == --help ]] || [[ $1 != -*[dD]* ]]; then
	echo "Usage : dradis.sh [OPTION]"
	echo "  dradis.sh -dps"
	echo "========================================"
	echo "  OPTIONS"
	echo "   -d	:Docker Install and Config"
	echo "   -D	:Dradis Setup"
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

if [[ $option == *[D]* ]]; then

	docker pull zuazo/dradis
	mkdir -p dbdata/
	docker run --name dradis -d --restart=always --publish 3000:3000 --volume "$(pwd)/dbdata:/dbdata" zuazo/dradis
fi