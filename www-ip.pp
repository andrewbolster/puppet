class { "php": }

class ipsite {
  package { "apache2": ensure => present, }

  package { "php5-cli": ensure => present }
  package { "php-apc": ensure => present, }
  package { "libssl-dev": ensure => present, }
  package { "libapache2-mod-php5": ensure => present, }

  package { "php-pear": ensure => present, }

  package { "mongodb":
    ensure => installed,
  }
  service { "mongodb":
    enable => true,
    ensure => running,
    require => Package["mongodb"],
  }
  package { 'mongo':
    ensure   => installed,
    provider => pecl,
    require => Package["php-pear"],
  }
  file { 'mongo.conf':
    notify => Service['apache2'],
    require => Package['libapache2-mod-php5'],
    path => '/etc/php5/apache2/conf.d/mongo.ini',
    content => "extension=mongo.so",
    mode    => 0640,
  }

  service { "apache2": ensure => "running", require => Package["apache2"], hasrestart=>true }
  user
  {
    'paul': groups => ["www-data"]

  }
  file
  {
    '/www':
    ensure => 'directory',
    mode => 2660,
    owner => 'www-data',
    group => 'www-data',
  }
  file
  {
    '/www/default':
    ensure => 'directory',
    mode => 2660,
    owner => 'www-data',
    group => 'www-data',
  }
  file
  {
    '/www/default/public':
    ensure => 'directory',
    mode => 2660,
    owner => 'www-data',
    group => 'www-data',
  }
  file
  {
    '/etc/apache2/mods-enabled/headers.load':
    ensure => link,
    target => '/etc/apache2/mods-available/headers.load',
    notify => Service["apache2"],
    require => Package["apache2"],
  }
  file
  {
    '/etc/apache2/mods-enabled/rewrite.load':
    ensure => link,
    target => '/etc/apache2/mods-available/rewrite.load',
    notify => Service["apache2"],
    require => Package["apache2"],
  }
  file
  {
    'default':
    notify	=> Service["apache2"],
    path    => '/etc/apache2/sites-available/000-default.conf',
    ensure  => present,
    mode    => 0640,
    content => "<VirtualHost *:80>
          ServerAdmin webmaster@paulfreeman.me.uk
          DocumentRoot /www/default/public
          <Directory />
                  Options FollowSymLinks
                  AllowOverride None
          </Directory>
          <Directory /www/default/public>
                  Options Indexes FollowSymLinks MultiViews
                  AllowOverride All
                  Order allow,deny
                  allow from all
          </Directory>
          <Directory /www/default>
                  AllowOverride None
          </Directory>
          ErrorLog /var/log/apache2/default_error.log
          LogLevel warn
          CustomLog /var/log/apache2/default_access.log combined
</VirtualHost>",
  }
}

include ipsite