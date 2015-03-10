echo "Result: ${METHOD_AUTO_RESULT}"

# Check if SYNC_SOURCE exists and if is accessible
if [ ${METHOD} == "existing" ]; then
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
