#!bin/bash
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/OddEssay/puppet.git
sudo apt-get install -y puppet
sudo apt-get install -y libgemplugin-ruby
sudo apt-get install -y ruby-hiera

sudo gem install puppet-module
sudo puppet module install puppetlabs/apt
sudo puppet module install nodes/php

