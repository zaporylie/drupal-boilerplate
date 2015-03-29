# Drupal Boilerplate for D7 and D8 projects

New version of drupal-boilerplate project which is now Docker-oriented. Use it to 
start new Drupal project or you can add it to existing project. All you need to 
do is:

````bash
curl -s https://raw.githubusercontent.com/zaporylie/drupal-boilerplate/master/scripts/install.sh | sh
````

That command will download repository for you and extract it to the current 
directory.

You can also do it manually - download [ZIP](https://github.com/zaporylie/drupal-boilerplate/archive/master.zip) 
file and extract it to preferred destination.

## Docker

zaporylie/drupal-boilerplate project has a few docker-compose YAML files which helps 
you to start group of containers required to run Drupal site. All you need to do is
type one of `docker-compose up` commands. More about how to "up" your project in
["Running"](#running) section.

### Requirements

* Linux

Since we want to use Docker containers to run our project we need our host to
has Linux operating system. Read more about docker requirements on 
http://docker.com
If you are OSX user - nothing is lost. You can use boot2docker 
or [docker-host](https://github.com/zaporylie/docker-host) which was a part of 
this project before but now is hosted as a separate project.

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

### Running <a id="running"></a>

All you need to do is execute one of following commands:
````
# To run default file (docker-compose.yml):
docker-compose up -d

# To run selected yml file:
docker-compose --file=docker-compose-production.yml up -d
````

Notice, that flag -d means detached mode so your project will be run in 
background mode. You can use `docker-compose logs` for more information about it.
`docker-compose ps` will give you overview about all running containers belongs
to project.

### Recommended additional containers:

* Use [nginx-proxy](https://github.com/jwilder/nginx-proxy) to get domain support 
for new project and proxy traffic on port 80 (eventually 443) to your container
(which, by default, has random port).

## Credits

Repository was created by zaporylie <jakub@piaseccy.pl> with Ny Media AS support.
