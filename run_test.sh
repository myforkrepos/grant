#!/usr/bin/env bash

set -e

rubies=("ruby-1.9.3" "ruby-2.0.0" "ruby-2.1.3" "ruby-2.2.3")
for i in "${rubies[@]}"
do
  echo "====================================================="
  echo "$i: Start Test"
  echo "====================================================="
  rvm $i exec bundle
  rvm $i exec bundle exec rspec spec
  echo "====================================================="
  echo "$i: End Test"
  echo "====================================================="
done