#!/usr/bin/env bash

# Install
if [[ $1 != new-project ]]; then
  cd /project/drupal
  /home/vagrant/.composer/vendor/drush/drush/drush sql-sync @staging @local -y
fi