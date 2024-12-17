#!/bin/sh
envsubst '${PSQL_NAME} ${PSQL_USER} ${PSQL_PASSWORD}' < /etc/nginx/conf.d/local.conf.template > /etc/nginx/conf.d/local.conf
exec nginx -g 'daemon off;'
