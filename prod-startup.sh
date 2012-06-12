#!/bin/sh
bundle exec unicorn_rails -c config/unicorn.conf.rb -D -E production
