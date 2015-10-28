FROM zaporylie/drupal:2
MAINTAINER Jakub Piasecki <jakub@piaseccy.pl>

COPY ./scripts/conf /root/conf/
COPY ./ /app
