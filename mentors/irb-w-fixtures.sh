#!/bin/bash

rake db:fixtures:load RAILS_ENV=test
script/console test
