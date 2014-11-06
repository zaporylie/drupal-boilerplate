#!/bin/bash

# Copy some defaults if do not exists
for f in /project/drush/defaults/modules/* ; do cp -n "$f" "/project/drush/modules" ; done
cp -n /project/drush/defaults/aliases/project.aliases.drushrc.php /project/drush/aliases/project.aliases.drushrc.php
cp -n /project/drush/defaults/aliases/local.aliases.drushrc.php /project/drush/local.aliases.drushrc.php
cp -n /project/drush/defaults/drushrc.php /project/drush/drushrc.php
cp -n /project/drush/defaults/local.drushrc.php /project/drush/local.drushrc.php

# Make room for non-exists project
if [ ! -d /project/drupal/sites/default ]; then

  # Download fresh copy of drupal
  if [ ! -d /tmp/drupal/sites/default ]; then
    cd /tmp
    drush dl drupal
    mv /tmp/drupal*/ /tmp/drupal
  fi

  # Copy drupal codebase from helper default location
  cp -r /tmp/drupal/. /project/drupal
  cd /project/drupal

  # Create basic module containers
  mkdir -p /project/drupal/sites/all/modules/contrib
  mkdir -p /project/drupal/sites/all/modules/custom
  mkdir -p /project/drupal/sites/all/drush

  # Symlink to drushrc inside sites/all/drush
  ln -s ../../../../drush/drushrc.php /project/drupal/sites/all/drush/drushrc.php

  # Download usefull modules
  drush dl fpa, module_filter, coffee, stage_file_proxy, devel, search_krumo -y --destination=sites/all/modules/contrib
fi

if [[ ! -f /project/drupal/sites/default/settings.php ]] || [[ $RESTART == true ]]; then
  # Reset settings file
  rm -f /project/drupal/sites/default/settings.php

  # Set new mysql root password
  source /project/environment/mysql.sh

  # Install vanilla Drupal
  cd /project/drupal/
  DRUPAL_PASSWORD=`pwgen -c -n -1 12`
  drush site-install minimal standard -y --account-name=admin --db-url="mysqli://drupal:${DRUPAL_PASSWORD}@localhost/drupal" --db-su=root --db-su-pw=$MYSQL_PASSWORD
fi

# Go back to your room!
cd

# Check if staging exists and if is accessible
if [ $(drush sa | grep staging | wc -l) == 1 ]; then
  if [ $(drush @staging st | grep "Connected" | wc -l) == 1 ]; then
    # Sync site here!
    drush sql-sync @staging @local -y
  fi
fi

# start all the services
if [ -f /usr/local/bin/supervisord ]; then
  /usr/local/bin/supervisord -n
fi
