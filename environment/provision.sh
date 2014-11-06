#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# Date
# https://help.ubuntu.com/community/UbuntuTime
TIMEZONE=$(head -n 1 "/etc/timezone")
if [ $TIMEZONE != "Europe/Oslo" ]; then
    echo "Europe/Oslo" | sudo tee /etc/timezone
    sudo dpkg-reconfigure --frontend noninteractive tzdata
fi

if [ ! -d "/opt/provisioned" ]; then
  mkdir /opt/provisioned
  apt-get -qq update

  # Install all kinds of useful stuff
  apt-get -y install vim nano wget sendmail pwgen unzip git curl
  apt-get -y install apache2 php5 mysql-server mysql-client libapache2-mod-php5 php5-mysql
  apt-get -y install php5-curl php5-gd php5-intl php-pear php5-imap php5-memcache memcached mc php-apc php5-fpm
  apt-get -y install php5-dev php5-xdebug libpcre3-dev

  mkdir /var/log/xdebug
  chown www-data:www-data /var/log/xdebug

  echo 'xdebug.remote_enable = 1' >> /etc/php5/mods-available/xdebug.ini
  echo 'xdebug.remote_connect_back = 1' >> /etc/php5/mods-available/xdebug.ini
  echo 'xdebug.idekey = "vagrant"' >> /etc/php5/mods-available/xdebug.ini
  echo 'xdebug.remote_log="/var/log/xdebug/xdebug.log"' >> /etc/php5/mods-available/xdebug.ini
  echo 'xdebug.profiler_enable_trigger = 1' >> /etc/php5/mods-available/xdebug.ini
  echo 'xdebug.profiler_output_dir="/project/output"' >> /etc/php5/mods-available/xdebug.ini
  echo 'xdebug.trace_enable_trigger = 1' >> /etc/php5/mods-available/xdebug.ini
  echo 'xdebug.trace_output_dir = "/project/output"' >> /etc/php5/mods-available/xdebug.ini
  echo 'xdebug.max_nesting_level = 1000' >> /etc/php5/mods-available/xdebug.ini

  a2enmod rewrite
  cp /project/environment/apache/drupal.conf /etc/apache2/sites-available/
  a2ensite drupal
  a2dissite 000-default
  usermod -a -G vagrant www-data
  /etc/init.d/apache2 restart

  # php-fpm config
  sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
  sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
  find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

  # Add composer
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer
  chmod uog+x /usr/local/bin/composer
  ln -s /usr/local/bin/composer /usr/bin/composer

  # Add drush
  git clone https://github.com/drush-ops/drush.git /usr/local/src/drush
  cd /usr/local/src/drush
  git checkout 6.x  #or whatever version you want.
  ln -s /usr/local/src/drush/drush /usr/bin/drush
  composer install
  drush --version

  # Symlink to project drushrc.php file.
  mkdir --parents /home/vagrant/.drush
  ln -s /project/drush/drushrc.php /home/vagrant/.drush/drushrc.php

  # Make all new files belong to vagrant user.
  chown vagrant:vagrant /home/vagrant -R

  su -c "source /project/environment/start.sh $1" vagrant
fi
