#! /bin/bash
###### Docker Setup
# update apt-get
export DEBIAN_FRONTEND="noninteractive"
sudo apt-get update

# remove previously installed Docker
sudo apt-get purge lxc-docker*
sudo apt-get purge docker.io*

# add Docker repo
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

cat > /etc/apt/sources.list.d/docker.list <<'EOF'
deb https://apt.dockerproject.org/repo debian-stretch main
EOF
sudo apt-get update

# install Docker
sudo apt-get install -y docker-engine
sudo service docker start
#sudo docker run hello-world


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
#############################################################################################

