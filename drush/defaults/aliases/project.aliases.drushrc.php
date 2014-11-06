<?php

$aliases['main'] = array(
  'target-command-specific' => array (
    'sql-sync' => array(
      // Add general options for sql-sync target here.
    ),
  ),
  'source-command-specific' => array(
    'sql-sync' => array(
      // Add general options for sql-sync source here.
    ),
  ),
  'command-specific' => array(
    'sql-sync' => array(
      'confirm-sanitizations' => TRUE,
    ),
  ),
  'path-aliases' => array(
    '%dump-dir' => '/tmp',
  ),
);

// use '-o StrictHostKeyChecking=no' to make new environment accessible for start.sh
$aliases['staging'] = array(
  'parent' => '@main',
  // 'uri' => '', // i.e. www.example.com
  // 'root' => '', // i.e. /var/www/example.com
  // 'remote-host' => '', // i.e. dev.example.com
  // 'ssh-options' => '-o StrictHostKeyChecking=no', // i.e. -p 23  -o StrictHostKeyChecking=no
);

$aliases['prod'] = array(
  'parent' => '@main',
  // 'uri' => '', // i.e. www.example.com
  // 'root' => '', // i.e. /var/www/example.com
  // 'remote-host' => '', // i.e. dev.example.com
  // 'ssh-options' => '', // i.e. -p 23
);

$aliases['local'] = array(
  'parent' => '@main',
  'root' => dirname(__FILE__) . '/../../drupal',
  'uri' => 'localhost',
  'target-command-specific' => array (
    'sql-sync' => array (
      'enable' => array(
        'devel',
        'search_krumo',
        'coffee',
        'stage_file_proxy',
        'module_filter',
        'fpa',
      ),
      'variables-set' => array(
        'stage_file_proxy_origin' => 'http://' . $aliases['staging']['uri'],
        'stage_file_proxy_hotlink' => 1,
      ),
      'no-cache' => TRUE,
      'sanitize' => TRUE,
      'no-ordered-dump' => TRUE,
    ),
  ),
);

// use '-o StrictHostKeyChecking=no' to make env accessible for start.sh
$aliases['dev'] = array(
  'parent' => '@main, @local',
  // 'uri' => '', // i.e. www.example.com
  // 'root' => '', // i.e. /var/www/example.com
  // 'remote-host' => '', // i.e. dev.example.com
  // 'ssh-options' => '-o StrictHostKeyChecking=no', // i.e. -p 23 -o StrictHostKeyChecking=no
);

/**
 * Load local development override configuration, if available.
 *
 * Use local.aliases.drushrc.php to override Drush aliases configuration.
 *
 * Keep this code block at the end of this file to take full effect.
 */
if (file_exists(dirname(__FILE__) . '/../local.aliases.drushrc.php')) {
  include dirname(__FILE__) . '/../local.aliases.drushrc.php';
}