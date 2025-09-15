#!/bin/bash
set -e

echo "Waiting for MySQL to be ready..."
if [ "$RAILS_ENV" == "test" ]; then
    while ! mysqladmin ping -h"test-db" -P"3306" -u"root" -p"password" --skip-ssl --silent; do
        sleep 2
    done
else
    while ! mysqladmin ping -h"db" -P"3306" -u"root" -p"password" --skip-ssl --silent; do
        sleep 2
    done
fi
echo "MySQL is ready!"

bundle exec rake db:create db:migrate

exec "$@"