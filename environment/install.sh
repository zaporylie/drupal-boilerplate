#!/usr/bin/env bash

wget https://github.com/zaporylie/drupal-boilerplate/archive/master.zip
unzip master.zip
cd drupal-boilerplate-master && mv * .[^.]* ../ && cd ../
rm -Rf drupal-boilerplate-master
rm master.zip
