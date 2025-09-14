#!/bin/bash
set -e

echo "Waiting for MySQL to be ready..."
while ! mysqladmin ping -h"db" -P"3306" -u"root" -p"password" --silent; do
  sleep 2
done

echo "MySQL is ready!"

bundle exec rake db:create db:migrate

exec "$@"