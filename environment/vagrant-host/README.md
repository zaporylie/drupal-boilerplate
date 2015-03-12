Host VM
==============================

So you want to use Docker containers on Mac or Windows? Yeah... that's possible
but requires one more level for your development environment.
 
But don't worry! It's not that bad :)

You can use some fancy tools, like boot2docker (so you'll get access to docker
directly from your host). I tried that - it takes a lot of time to configure it
and it doesn't work that well. So I decided to write this small Ubuntu based
vagrant box. **Finally simplest solutions are the best!**


## Requirements
Vagrant 
https://github.com/cogitatio/vagrant-hostsupdater

## Instalation

1. To make it easy keep projects you are working on in this directory.
2. `vagrant up` then `vagrant ssh` from anywhere inside this directory.
3. `sudo docker ps` you can start right away!

I still recommend to use git, vim or other tools on your code on your host - it 
is probably more convenient. I believe that you will use vagrant only to run 
docker-compose on project, eventually re-run it.
