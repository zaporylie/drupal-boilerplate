# Dockerfile for Drupal project

FROM    ubuntu:latest
MAINTAINER Jakub Piasecki <jakub@nymedia.no>

#RUN echo "deb http://archive.ubuntu.com/ubuntu raring main restricted universe multiverse" > /etc/apt/sources.list
RUN apt-get update

# Keep upstart from complaining
#RUN dpkg-divert --local --rename --add /sbin/initctl
#RUN ln -s /bin/true /sbin/initctl

# Add usefull libraries
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install vim nano wget sendmail pwgen unzip git curl

# Basic Requirements
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 php5 mysql-server mysql-client libapache2-mod-php5 php5-mysql

# Drupal Requirements
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-curl php5-gd php5-intl php-pear php5-imap php5-memcache memcached mc php-apc php5-fpm

# Development tools
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-dev php5-xdebug libpcre3-dev

# Sysadmin tools
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python-setuptools

RUN apt-get clean

# Make mysql listen on the outside
#RUN sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf

# Sync folders
VOLUME ['/project']

# apache2 config
RUN a2enmod rewrite
ADD ./environment/apache/drupal.conf /etc/apache2/sites-available/
RUN a2ensite drupal
RUN a2dissite 000-default

# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# Add composer and drush
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN ln -s /usr/local/bin/composer /usr/bin/composer
RUN wget https://github.com/drush-ops/drush/archive/6.x.zip && unzip 6.x.zip && mv drush-6.x /usr/local/src/drush
RUN cd /usr/local/src/drush && composer install
RUN ln -s /usr/local/src/drush/drush /usr/bin/drush

# Supervisor Config
RUN /usr/bin/easy_install supervisor
ADD ./environment/supervisord.conf /etc/supervisord.conf

# Add drushrc.php for root user
RUN mkdir --parents /root/.drush
RUN ln -s /project/drush/drushrc.php /root/.drush/drushrc.php

# Allow to add id_rsa
VOLUME ['/root/.ssh']

EXPOSE 80
CMD ["/bin/bash", "/project/environment/start.sh"]
