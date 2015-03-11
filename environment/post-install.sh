#!/bin/sh
echo "Result: ${METHOD_AUTO_RESULT}"

# Make sure that we have all usefull modules for dev environment
if [ "${ENVIRONMENT}" = "DEV" ]; then
  cd /app/drupal && drush dl fpa, module_filter, coffee, stage_file_proxy, devel, search_krumo -y --destination=sites/all/modules/contrib
fi

# Check if SYNC_SOURCE exists and if is accessible
echo "Synchronize: ${SYNC}"
if [ ${SYNC} ]; then
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
fi
