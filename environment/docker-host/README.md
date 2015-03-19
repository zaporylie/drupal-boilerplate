Docker Host
==============================

So you want to use Docker containers on Mac? Yeah... that's possible but 
requires one more level for your development environment.
 
But don't worry! It's not that bad :)

You can use some fancy tools, like boot2docker (so you'll get access to docker
directly from your host). I tried that - it takes a lot of time to configure it
and it doesn't work that well. So I decided to write this small Ubuntu based
vagrant box. **Finally - simplest solutions are the best!**


## Requirements

* Vagrant (with VirtualBox)
* [Vagrant-hostupdater](https://github.com/cogitatio/vagrant-hostsupdater)
* [Vagrant-bindfs](https://github.com/gael-ian/vagrant-bindfs)

## Instalation

1. To make it easy keep projects you are working on in this directory.
2. `vagrant up` then `vagrant ssh` from anywhere inside this directory.
3. `docker ps` you can start right away!

I still recommend to use git, vim or other tools on your host - it 
is probably more convenient. I believe you will use vagrant only to run 
`docker-compose up`, eventually manage your images/containers.

## Known issues

* To deal with file permissions we use bindfs (so first mount nfs to tmp 
location, then bindfs locally with ownership change). It can cause small 
performance issues.
* You can't change file ownership but, in the same time, bindfs takes care to
mirror ownership, so vagrant, root and www-data "think" that they are file 
owners. It can cause security issues (drupal core will be writable for www-data).
