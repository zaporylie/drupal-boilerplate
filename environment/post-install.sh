#!/bin/sh

#if ( [ ! -d /app/drupal/sites/${DRUPAL_SUBDIR}/files ] && [ ! -L /app/drupal/sites/${DRUPAL_SUBDIR}/files ] ) || [ "${METHOD_AUTO_RESULT}" = "new_install" ]; then
#  rsync -av /app/drupal/sites/${DRUPAL_SUBDIR}/files/ /app/public/${DRUPAL_SUBDIR}  > /dev/null 2>&1
#  rm -rf /app/drupal/sites/${DRUPAL_SUBDIR}/files  > /dev/null 2>&1
#  ln -s ../../../public/${DRUPAL_SUBDIR} /app/drupal/sites/${DRUPAL_SUBDIR}/files > /dev/null 2>&1
#fi

echo "Result: ${METHOD_AUTO_RESULT}"

# Make sure that we have all usefull modules for dev environment
if [ "${ENVIRONMENT}" = "DEV" ] && [ "${METHOD_AUTO_RESULT}" = "new_install" ]; then
  cd /app/drupal && drush dl fpa, module_filter, coffee, stage_file_proxy, devel, search_krumo, reroute_email -y --destination=sites/all/modules/contrib
fi

# Check if SYNC_SOURCE exists and if is accessible
echo "Synchronization method: ${SYNC_METHOD}"
if [ "${SYNC_METHOD}" = "AUTO" ] && [ "${METHOD_AUTO_RESULT}" = "new_install" ]; then
  if [ "$(drush sa | grep "${DRUPAL_SUBDIR}.${SYNC_SOURCE}" | wc -l)" == 1 ]; then
    if [ "$(drush @"${DRUPAL_SUBDIR}.${SYNC_SOURCE}" st | grep 'Connected' | wc -l)" == 1 ]; then
      # Change max_allowed_packet
      mysql -h${MYSQL_HOST_NAME} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD} -e "set global max_allowed_packet=64*1024*1024;"
      # Sync site here!
      drush sql-sync @"${DRUPAL_SUBDIR}.${SYNC_SOURCE}" @"${DRUPAL_SUBDIR}.local" -y
    else
      echo "Unable to sync: cannot connect to ${DRUPAL_SUBDIR}.${SYNC_SOURCE}"
    fi
  else
    echo "Unable to sync: ${DRUPAL_SUBDIR}.${SYNC_SOURCE} is not defined"
  fi

elif [ "${SYNC_METHOD}" = "FILE" ] && [ -f /var/backups/db.sql ] && [ "${METHOD_AUTO_RESULT}" = "new_install" ]; then
  # Change max_allowed_packet
  mysql -h${MYSQL_HOST_NAME} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD} -e "set global max_allowed_packet=64*1024*1024;"
  echo "File exist, start syncing"
  cd /app/drupal/sites/${DRUPAL_SUBDIR} && drush sql-cli -y < /var/backups/db.sql
else
  echo "Do nothing"
fi
