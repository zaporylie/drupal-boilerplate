#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# https://help.ubuntu.com/community/UbuntuTime
TIMEZONE=$(head -n 1 "/etc/timezone")
if [ $TIMEZONE != "Europe/Oslo" ]; then
    echo "Europe/Oslo" | sudo tee /etc/timezone
    sudo dpkg-reconfigure --frontend noninteractive tzdata
fi

if [ ! -d "/opt/provisioned" ]; then

  # Install required tools
  apt-get update && apt-get -y install curl vim nano

  # Install docker
  curl -sSL https://get.docker.com/ubuntu/ | sudo sh

  # Install docker-compose
  curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose

  usermod -m -d /home/share vagrant

  docker pull zaporylie/drupal-dev
  docker pull mysql:5.5
fi

# This command will keep nginx proxy up and running
docker run --name proxy -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock -t jwilder/nginx-proxy > /dev/null 2>&1
docker start proxy > /dev/null 2>&1
