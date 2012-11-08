package { "apache2": ensure => present, }
service { "apache2": ensure => "running", require => Package["apache2"], hasrestart=>true }
package { "phpmyadmin": ensure=> present }
file {
        'phpmyadmin-conf':
                ensure => file,
                path => '/etc/apache2/conf.d/phpmyadmin.conf',
                source => '/etc/phpmyadmin/apache.conf',
                replace => true
}
file
{
	'/etc/apache2/mods-enabled/headers.load':
		ensure => link,
		target => '/etc/apache2/mods-available/headers.load',
		notify => Service["apache2"],
}
file
{
        '/etc/apache2/mods-enabled/rewrite.load':
                ensure => link,
                target => '/etc/apache2/mods-available/rewrite.load',
		notify => Service["apache2"],
}
file
{
	'vagrant':
		notify	=> Service["apache2"],
		path    => '/etc/apache2/sites-enabled/000-default',
		ensure  => file,
		mode    => 0640,
                replace   => true,
		content => "
	<VirtualHost *:80>
        ServerAdmin paul@mojo-projects.com
        ServerName localhost
        DocumentRoot /vagrant/public
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory /vagrant>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>
        <Directory /vagrant/public>
                AllowOverride All
        </Directory>
        ErrorLog /var/log/apache2/vagrant_error.log
        LogLevel warn
        CustomLog /var/log/apache2/vagrant_access.log combined
</VirtualHost>",
}
file {
        'php-ini':
                ensure => file,
                notify => Service["apache2"],
                path => '/etc/php5/apache2/php.ini',
                source => '/vagrant/puppet/php.ini',
                replace => true
}
