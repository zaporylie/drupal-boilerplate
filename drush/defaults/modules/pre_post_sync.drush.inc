<?php

/**
 * Implements drush_hook_post_COMMAND().
 */
function drush_pre_post_sync_pre_sql_sync($source = NULL, $destination = NULL) {
  // Clean database?
  drush_invoke_process($destination, 'sql-query', array("DROP TABLE IF EXISTS {cache_coffee}"), array('db-prefix' => TRUE));
}

/**
 * Implements drush_hook_post_COMMAND().
 */
function drush_pre_post_sync_post_sql_sync($source = NULL, $destination = NULL) {
  drush_invoke_process($destination, 'uli');
}
