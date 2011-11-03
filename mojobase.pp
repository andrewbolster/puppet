class mojobase
{
	package { "vim": ensure => present, }
	package { "byobu": ensure => present, }
	package { "apache2": ensure => present, }
	service
	{
		"apache2":
			ensure => running,
			require => Package["apache2"],
	}
	package { "git-core": ensure => present, }
	package { "ruby-rvm": ensure => present, }
	package { "php-apc": ensure => present, }
	package { "libapache2-mod-php5": ensure => present, }
	package { "php5-memcache": ensure => present, }
	package { "php5-mysql": ensure => present, }
	package { "php5-xdebug": ensure => present, }
	package { "memcached": ensure => present, }
	service
	{
		"memcached":
			ensure => running,
			require => Package["memcached"]
	}
	package { "mysql-server": ensure => present, }
	service
	{
		"mysql":
			ensure => running,
			require => Package["mysql-server"],
	}
}
include mojobase
