# Drupal Boilerplate

## Vagrant way

### Getting started with existing project
1. Be sure that your identity is available to the local ssh-agent, use: `ssh-add -L`. Add it if not: `ssh-add ~/.ssh/id_rsa`
1. Copy /drush/defaults/aliases/local.aliases.drushrc.php to /drush and specify your username for each environment.
1. Type `vagrant up` in terminal to start new VirtualBox
1. Use ports specified in /environment/Vagrantfile to reach your services (could be different in case of collisions)
1. Login to vagrant via ssh: `vagrant ssh`
1. Create feature branch from develop or staging branch
1. Open your IDE and start coding

### Starting new project
1. You can start new project by downloading this respository (do not clone it, you'll probably want to build new repository).
1. Go to /Vagrantfile and specify ports forwarding for new project (it's easier to use defined ports)
1. Use `vagrant up` to create new project. It will download last version of drupal for you, and place it in /drupal folder
1. You will got also new set of drush-related files (in /drush), copied from /drush/defaults. Go to /drush/aliases/project.aliases.drushrc.php and setup project specific environmental data.
1. Commit and push all changes to git repo. Be sure that user sensitive data is not stored in repository.
1. Clone repo on dev and staging and configure it.

## Docker way
You can build it first based on Dockerfile:
````
docker build -t zaporylie/drupal-boilerplate <path_to_Dockerfile_directory>
````

than:

1. Be sure that your ssh identity allows you to connect @staging server (in case you want to work on existing project - syn via drush sql-sync @staging @local)
1. Copy /drush/defaults/aliases/local.aliases.drushrc.php to /drush and specify your username for each environment.
1. Run command: 
````
docker run --name='<container_name>' -d -t -i -e VIRTUAL_HOST=<domain_if_you_use_nginx_proxy> -v <path_to_project>:/project -v ~/.ssh:/root/.ssh zaporylie/drupal-boilerplate
````

* Use [nsenter](https://github.com/jpetazzo/nsenter) to connect your Docker: `docker-enter <container_name>`
* Use [nginx-proxy](https://github.com/jwilder/nginx-proxy) to setup domain for new project
