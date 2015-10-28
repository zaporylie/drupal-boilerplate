#!/bin/sh

cd /app/drupal > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '[error] Drupal folder could not be found'
  exit 1;
fi

# Download fpa if unavailable
if [ "$(drush pml | grep fpa | wc -l)" = "0" ]; then
  drush dl fpa -y --destination=sites/all/modules/contrib
fi

# Download module_filter if unavailable
if [ "$(drush pml | grep module_filter | wc -l)" = "0" ]; then
  drush dl module_filter -y --destination=sites/all/modules/contrib
fi

# Download coffee if unavailable
if [ "$(drush pml | grep coffee | wc -l)" = "0" ]; then
  drush dl coffee -y --destination=sites/all/modules/contrib
fi

# Download stage_file_proxy if unavailable
if [ "$(drush pml | grep stage_file_proxy | wc -l)" = "0" ]; then
  drush dl stage_file_proxy -y --destination=sites/all/modules/contrib
fi

# Download devel if unavailable
if [ "$(drush pml | grep devel | wc -l)" = "0" ]; then
  drush dl devel -y --destination=sites/all/modules/contrib
fi

# Download search_krumo if unavailable
if [ "$(drush pml | grep search_krumo | wc -l)" = "0" ]; then
  drush dl search_krumo -y --destination=sites/all/modules/contrib
fi

# Download reroute_email if unavailable
if [ "$(drush pml | grep reroute_email | wc -l)" = "0" ]; then
  drush dl reroute_email -y --destination=sites/all/modules/contrib
fi
