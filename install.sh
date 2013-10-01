#!bin/bash
sudo apt-get install -y git
git clone https://github.com/OddEssay/puppet.git
sudo apt-get install -y puppet
sudo puppet module install puppetlabs/apt
sudo puppet module install nodes/php

