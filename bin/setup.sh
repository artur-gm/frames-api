#!/bin/bash
docker-compose build
docker-compose run app bundle exec rake db:create db:migrate