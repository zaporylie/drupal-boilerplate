#!/bin/sh

if ( [ ! -d /app/drupal/sites/${DRUPAL_SUBDIR}/files ] && [ ! -L /app/drupal/sites/${DRUPAL_SUBDIR}/files ] ) || [ "${METHOD_AUTO_RESULT}" = "new_install" ]; then
  rsync -av /app/drupal/sites/${DRUPAL_SUBDIR}/files/ /app/public/${DRUPAL_SUBDIR}  > /dev/null 2>&1
  rm -rf /app/drupal/sites/${DRUPAL_SUBDIR}/files  > /dev/null 2>&1
  ln -s ../../../public/${DRUPAL_SUBDIR} /app/drupal/sites/${DRUPAL_SUBDIR}/files > /dev/null 2>&1
fi

echo "Result: ${METHOD_AUTO_RESULT}"

# Make sure that we have all usefull modules for dev environment
if [ "${ENVIRONMENT}" = "DEV" ] && [ "${METHOD_AUTO_RESULT}" = "new_install" ]; then
  cd /app/drupal && drush dl fpa, module_filter, coffee, stage_file_proxy, devel, search_krumo, reroute_email -y --destination=sites/all/modules/contrib
fi

# Check if SYNC_SOURCE exists and if is accessible
echo "Synchronization method: ${SYNC_METHOD}"
if [ "${SYNC_METHOD}" = "AUTO" ]; then
  if [ "$(drush sa | grep "${SYNC_SOURCE}" | wc -l)" == 1 ]; then
    if [ "$(drush @"${SYNC_SOURCE}" st | grep 'Connected' | wc -l)" == 1 ]; then
      # Sync site here!
      drush sql-sync @${SYNC_SOURCE} @local -y
    else
      echo "Unable to sync: cannot connect to ${SYNC_SOURCE}"
    fi
  else
    echo "Unable to sync: ${SYNC_SOURCE} is not defined"
  fi

elif [ "${SYNC_METHOD}" = "FILE" ] && [ -f /var/backups/db.sql ]; then
  echo "File exist, start syncing"
  drush @local sql-cli -y < /var/backups/db.sql
else
  echo "Do nothing"
fi
