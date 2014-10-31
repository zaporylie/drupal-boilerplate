<?php
/*
 * Defines environment flow.
 *
 * This flow will be used in:
 * - sql-sync
 */
$options['env-flow'] = array(
  '@prod' => array(),
  '@staging' => array('@prod'),
  '@dev' => array('@prod', '@staging'),
  '@local' => array('@prod', '@staging', '@dev'),
);

/**
 * Point to places where modules and aliases are stored.
 */
$options['include'] = dirname(__FILE__) . '/modules';
$options['alias-path'] = dirname(__FILE__) . '/aliases';

/**
 * Rest of options.
 */
// Keep dump as small as possible.
$options['structure-tables'] = array(
  'common' => array(
    'cache*',
    'session',
    'watchdog',
    'history',
  ),
);
$options['structure-tables-key'] = 'common';

// Add usefull aliases.
$options['shell-aliases']['noncore'] = 'pm-list --no-core';
$options['shell-aliases']['wipe'] = 'cache-clear all';
$options['shell-aliases']['unsuck'] = 'pm-disable -y overlay,dashboard';


/**
 * Use local.drushrc.php file to override Drush aliases configuration.
 *
 * Keep this code block at the end of this file to take full effect.
 */
if (file_exists(dirname(__FILE__) . '/local.drushrc.php')) {
  include dirname(__FILE__) . '/local.drushrc.php';
}