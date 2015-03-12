Keep your public files here and symlink it to files folder on demand. Recommend 
to keep in in folder named as site folder in /drupal/sites/[folder name] 

ex. 
  /drupal/sites/default => /public/default
  # ln -s ../../../public/default /drupal/sites/default/files
  