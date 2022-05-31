#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php "$@"
fi

chown www-data:www-data -R /var/www/html/conf/
if [ -n "$DOLIBARR_DOCUMENTS" ]; then
  chown www-data:www-data -R $DOLIBARR_DOCUMENTS
fi

exec "$@"