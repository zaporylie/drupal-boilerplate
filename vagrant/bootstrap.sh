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
  echo 'mysql-server-5.1 mysql-server/root_password password vagrant' | debconf-set-selections
  echo 'mysql-server-5.1 mysql-server/root_password_again password vagrant' | debconf-set-selections
  apt-get -qq -y install build-essential git curl vim apache2 php5 libapache2-mod-php5 mysql-server php-pear php5-gd php5-mysql libpcre3-dev php5-dev php-apc php5-xdebug

  mkdir /var/log/xdebug
  chown www-data:www-data /var/log/xdebug

  echo '' >> /etc/php5/apache2/php.ini
  echo ';;;;;;;;;;;;;;;;;;;;;;;;;;' >> /etc/php5/apache2/php.ini
  echo '; Added to enable Xdebug ;' >> /etc/php5/apache2/php.ini
  echo ';;;;;;;;;;;;;;;;;;;;;;;;;;' >> /etc/php5/apache2/php.ini
  echo '' >> /etc/php5/apache2/php.ini
  echo 'xdebug.remote_enable = 1' >> /etc/php5/apache2/php.ini
  echo 'xdebug.remote_connect_back = 1' >> /etc/php5/apache2/php.ini
  echo 'xdebug.idekey = "vagrant"' >> /etc/php5/apache2/php.ini
  echo 'xdebug.remote_log="/var/log/xdebug/xdebug.log"' >> /etc/php5/apache2/php.ini

  echo '' >> /etc/php5/cli/php.ini
  echo ';;;;;;;;;;;;;;;;;;;;;;;;;;' >> /etc/php5/cli/php.ini
  echo '; Added to enable Xdebug ;' >> /etc/php5/cli/php.ini
  echo ';;;;;;;;;;;;;;;;;;;;;;;;;;' >> /etc/php5/cli/php.ini
  echo '' >> /etc/php5/cli/php.ini
  echo 'xdebug.remote_enable = 1' >> /etc/php5/cli/php.ini
  echo 'xdebug.remote_connect_back = 1' >> /etc/php5/cli/php.ini
  echo 'xdebug.idekey = "vagrant"' >> /etc/php5/cli/php.ini
  echo 'xdebug.remote_log="/var/log/xdebug/xdebug.log"' >> /etc/php5/cli/php.ini

  a2enmod rewrite
  cp /vagrant/apache/drupal.conf /etc/apache2/sites-available/
  a2ensite drupal
  a2dissite 000-default
  usermod -a -G vagrant www-data
  /etc/init.d/apache2 restart

  # Use wget to install composer, to avoid SlowTimer errors
  wget -q "https://getcomposer.org/composer.phar"
  mv composer.phar /usr/local/bin/composer

  # Do some preperation, pretending we are the vagrant user.
  HOME=/home/vagrant
  sed -i '1i export PATH="$HOME/.composer/vendor/bin:$PATH"' $HOME/.bashrc
  chmod uog+x /usr/local/bin/composer

  # Download drush.
  /usr/local/bin/composer global require drush/drush:6.*
  mkdir /home/vagrant/.drush

  # Symlink to project drushrc.php file.
  ln -s /project/drush/drushrc.php /home/vagrant/.drush/drushrc.php

  # Make copies of defaults
  for f in /project/drush/defaults/modules/* ; do cp -n "$f" "/project/drush/modules" ; done
  cp -n /project/drush/defaults/aliases/project.aliases.drushrc.php /project/drush/aliases/project.aliases.drushrc.php
  cp -n /project/drush/defaults/aliases/local.aliases.drushrc.php /project/drush/local.aliases.drushrc.php
  cp -n /project/drush/defaults/drushrc.php /project/drush/drushrc.php

  # Install helper Drupal instance.
  mkdir /home/vagrant
  /home/vagrant/.composer/vendor/drush/drush/drush dl drupal --destination=/home/vagrant --drupal-project-rename=drupal

  # Conditionally download drupal to /project/drupal folder and configure it
  if [[ $1 == new-project ]]; then
    cd /project/drupal
    cp -r /home/vagrant/drupal/. /project/drupal
    mkdir -p /project/drupal/sites/all/modules/contrib
    mkdir -p /project/drupal/sites/all/modules/custom
    mkdir -p /project/drupal/sites/all/drush
    ln -s ../../../../drush/drushrc.php /project/drupal/sites/all/drush/drushrc.php
    /home/vagrant/.composer/vendor/drush/drush/drush dl fpa, module_filter, coffee, stage_file_proxy, devel, search_krumo -y --destination=sites/all/modules/contrib
  fi

  # Create vanilla drupal database
  cd /project/drupal
  /home/vagrant/.composer/vendor/drush/drush/drush si --db-url=mysql://drupal:drupal@localhost/drupal --db-su=root --db-su-pw=vagrant -y

  cd /home/vagrant/drupal
  /home/vagrant/.composer/vendor/drush/drush/drush si --db-url=mysql://drupal:drupal@localhost/drupal-helper --db-su=root --db-su-pw=vagrant -y

  # Make all new files belong to vagrant user.
  chown vagrant:vagrant /home/vagrant -R

  su -c "source /project/vagrant/user-config.sh $1" vagrant
fi
