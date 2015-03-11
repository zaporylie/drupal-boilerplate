#!/bin/sh

# For now only Drush 6 supports sql-sync
if [ "${DRUPAL_MAJOR_VERSION}" = "7" ] && [ "${SYNC_METHOD}" = "AUTO" ]; then
  composer global require drush/drush:6.1.0
fi

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

mkdir -p /app/public
mkdir -p /app/public/${DRUPAL_SUBDIR}
chown www-data:www-data /app/public/${DRUPAL_SUBDIR}

mkdir -p /app/private/${DRUPAL_SUBDIR}
chown www-data:www-data /app/private/${DRUPAL_SUBDIR}


# Wait for database
while ! mysql -h${MYSQL_HOST_NAME} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD}  -e ";" ; do
  sleep 0.5
done
echo "Connected to ${MYSQL_HOST_NAME}";
