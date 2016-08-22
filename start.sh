#!/bin/sh
rake db:create db:migrate
puma -C config/puma.rb
