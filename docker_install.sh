#! /bin/bash
###### Docker Setup

cd /root/
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

###### Bloodhound Download
wget https://github.com/adaptivethreat/BloodHound/releases/download/1.1/BloodHound-linux-x64.zip -O /root/BloodHound-linux-x64.zip
unzip /root/BloodHound-linux-x64.zip -d /root

docker pull neo4j
docker run --name bloodhound -d --restart=always -p 127.0.0.1:7474:7474 -p 127.0.0.1:7687:7687 neo4j
docker stop bloodhound

rm /root/BloodHound-linux-x64.zip

###### MATTERMOST CHAT
docker pull mattermost/mattermost-preview
docker run --name mattermost -d --restart=always --publish 127.0.0.1:8065:8065 mattermost/mattermost-preview
docker stop mattermost
docker rm mattermost

###### AD Control Mapping
cp /root/github/Crowe-Scripts/ad-control-mapping-master.zip /root/ad-control-mapping-master.zip
unzip /root/ad-control-mapping-master.zip -d /root
rm /root/ad-control-mapping-master.zip

cd /root/ad-control-mapping-master
docker-compose build
docker-compose up -d
docker-compose exec app rake db:create db:migrate assets:precompile
docker run adcontrolmappingmaster_app
docker stop adcontrolmappingmaster_app


#############################################################################################

