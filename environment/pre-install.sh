#!/bin/sh

# Copy some defaults if do not exists
for f in /app/drush/defaults/modules/* ; do cp -n "$f" "/app/drush/modules" ; done
cp -n /app/drush/defaults/aliases/app.aliases.drushrc.php /app/drush/aliases/app.aliases.drushrc.php
cp -n /app/drush/defaults/aliases/local.aliases.drushrc.php /app/drush/local.aliases.drushrc.php
cp -n /app/drush/defaults/drushrc.php /app/drush/drushrc.php
cp -n /app/drush/defaults/local.drushrc.php /app/drush/local.drushrc.php

# Symlink to project drushrc.php file.
mkdir -p $HOME/.drush
ln -s /app/drush/drushrc.php $HOME/.drush/drushrc.php

# Create basic module containers
mkdir -p /app/drupal/sites/all/modules/contrib
mkdir -p /app/drupal/sites/all/modules/custom
mkdir -p /app/drupal/sites/all/drush

# Symlink to drushrc inside sites/all/drush
ln -s ../../../../drush/drushrc.php /app/drupal/sites/all/drush/drushrc.php

if [ ! -d /app/drupal/sites/${DRUPAL_SUBDIR}/files ]; then
  mkdir -p /app/public
  mkdir -p /app/public/${DRUPAL_SUBDIR}
  ln -s ../../../public/${DRUPAL_SUBDIR} /app/drupal/sites/${DRUPAL_SUBDIR}/files
  chown www-data:www-data /app/public/${DRUPAL_SUBDIR}
fi

if [ ! -d /app/private/${DRUPAL_SUBDIR} ]; then
  mkdir -p /app/private/${DRUPAL_SUBDIR}
  chown www-data:www-data /app/private/${DRUPAL_SUBDIR}
fi

# Wait for database
while ! mysql -h${MYSQL_HOST_NAME} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD}  -e ";" ; do
  sleep 0.5
done
echo "Connected to ${MYSQL_HOST_NAME}";
