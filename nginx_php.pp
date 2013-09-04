class { "apt": }
class { "php": }
class nginx_php {
	require nginx_apt
	package { "nginx": ensure => installed }	
	package { "php5-fpm": ensure => installed }
	package { "php5-cli": ensure => installed }
	package { "php5-dev": ensure => installed }
	package { "php-pear": ensure => installed, require => Package['php5-dev'] }
	
	package { "mongodb": ensure => installed }
	package { 'mongo':
		ensure   => installed,
		provider => pecl,
		require => Package["php-pear"]
	}
	file { 'mongo.conf':
		notify => Service['php5-fpm'],
		path => '/etc/php5/fpm/conf.d/mongo.ini',
		content => "extension=mongo.so",
		mode    => 0640,
	}
	service { "nginx": ensure => "running", require => Package["nginx"], hasrestart=>true }	
	service { "php5-fpm": ensure => "running", require => Package['php5-fpm'], hasrestart=>true }
}
class nginx_apt {
	 apt::ppa { "ppa:nginx/stable": }
}
include nginx_php
