#!/bin/sh

cd /app/drupal > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Drupal folder could not be found'
  exit 1;
fi

drush updb -y
