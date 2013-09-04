class { 'apt': }
class digitalocean {
	require nodejs
	package { "vim": ensure => present, }
	package { "ufw": ensure => present, }
	package { "git-core": ensure => present, }
	exec { "/usr/bin/npm install -g yo": }
	exec { "/usr/bin/npm install -g grunt-cli": }
	exec { "/usr/bin/npm install -g bower": } 

}
class nodejs_req {
	package { "software-properties-common": ensure => present, }
	package { "python-software-properties": ensure => present, }
	package { "python": ensure => present, }
	package { "g++": ensure => present, }
	package { "make": ensure => present, }
	apt::ppa { "ppa:chris-lea/node.js": }
}
class nodejs {
	require nodejs_req
	package { "nodejs": ensure => present, }
}
include digitalocean
