class mojobase
{
	package
	{
		"vim":
			ensure => present,
	}
	package
	{
		"apache2":
			ensure => present, 
	}
	service
	{
		"apache2":
			ensure => running,
			require => Package["apache2"],
	}
	package { "git-core": ensure => present, }
	package { "ruby-rvm": ensure => present, }
	package { "php-apc": ensure => present, }
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
}
include mojobase
