# Drupal Boilerplate for D7 and D8 projects

This is new version of this boilerplate project which is Docker-oriented 
only. Use it to start new Drupal project.

## Docker way

Right now this is the only supported way of running projects, although
you can run docker host with vagrant for OSX support (it's still
much faster than separate VBox-per-project).

### Requirements

* [docker](https://docs.docker.com/installation/ubuntulinux/)
````
# You can use this command on Ubuntu to install it.
curl -sSL https://get.docker.com/ubuntu/ | sudo sh
````
* [docker-compose](http://docs.docker.com/compose/install/)
````
# The easiest way to install on ubuntu is:
curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
````
or run docker-host which will install everything for you.

### Running

All you need is one of these commands:
````
# To run selected yml file:
docker-compose --file=docker-compose-production.yml up -d
# To run default file (docker-compose.yml):
docker-compose up -d
# or create another .yml file right for your environment/configuration
# and run it.
````
Notice, that flag -d means detached mode, so use `docker-compose logs` for more
information about running services.

## Vagrant (docker-host)

For vagrant support, check [/environment/docker-host](environment/docker-host)

### Requirements for vagrant docker-host

- [Vagrant, obviously](https://www.vagrantup.com/)
- bindfs plugin (Install with `vagrant plugin install vagrant-bindfs`)
- hostsupdater plugin (Install with `vagrant plugin install vagrant-hostsupdater`)

## Usefull containers:

* Use [nginx-proxy](https://github.com/jwilder/nginx-proxy) to get domain support 
for new project and proxy traffic on port 80 (eventually 443) to your container
(which, by default, has random port).
Notice, that nginx-proxy will be ready and running if you will start with [docker-host](environment/docker-host)
