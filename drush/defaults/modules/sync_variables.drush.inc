<?php

/**
 * Implements hook_drush_help_alter().
 */
function sync_variables_drush_help_alter(&$command) {
  if ($command['command'] == 'sql-sync') {
    $command['options']['variables-set']  = "Set new value for variable.";
  }
}

/**
 * Implements drush_hook_post_COMMAND().
 */
function drush_sync_variables_post_sql_sync($source = NULL, $destination = NULL) {
  $variables_to_set = drush_get_option_list('variables-set');
  if (!empty($variables_to_set)) {
    foreach ($variables_to_set as $variable => $value) {
      drush_log(dt("Set !variable = !value post-sql-sync", array('!variable' => $variable, '!value' => $value)), 'ok');
      drush_invoke_process($destination, 'variable-set', array($variable, $value));
    }
  }
}
