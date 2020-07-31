#!/bin/bash

if [ ${ENABLE_DB_MIGRATE} -eq '1' ]; then
bundle exec rake db:migrate
fi
if [ ${ENABLE_ASSETS_PIPELINE} -eq '1' ]; then
bundle exec rake assets:precompile
fi
bundle exec unicorn -p 3000 -c /var/www/discourse/config/unicorn.rb