# Drupal Boilerplate for D7 and D8 projects

This is new version of this repository where I changed logic from Vagrant first
to Docker first. Use it to start new Drupal project.

## Docker way

Right now this is the only supported way of running projects, although
you can run vagrant host around docker containers for OSX support (it's still
much faster than separate VBox-per-project).

### Requirements

* [docker](https://docs.docker.com/installation/ubuntulinux/)
````
curl -sSL https://get.docker.com/ubuntu/ | sudo sh
````
* [docker-compose](http://docs.docker.com/compose/install/)
````
curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
````

### Running

All you need is run one of these commands:
````
docker-compose --file=docker-compose-production.yml up -d
# or
docker-compose --file=docker-compose-development.yml up -d
````
Notice that flag -d means detached mode so use `docker-compose logs` for more
information about running services.

## Vagrant way

For vagrant support, check /enviroment/vagrant-host 

## Usefull containers:

* Use [nginx-proxy](https://github.com/jwilder/nginx-proxy) to get domain support 
for new project and proxy traffic on port 80 (eventually 443) to your container
(which, by default, has random port).
