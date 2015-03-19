#!/usr/bin/env bash

curl -Lk https://github.com/zaporylie/drupal-boilerplate/archive/master.tar.gz |  tar -zxf -
cp -Ri drupal-boilerplate-master/* drupal-boilerplate-master/.[^.]* ./
rm -Rf drupal-boilerplate-master
