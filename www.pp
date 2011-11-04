package { "apache2": ensure => present, }
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
	'pims2':
		notify	=> Service["apache2"],
		path    => '/etc/apache2/sites-enabled/pims2',
		ensure  => present,
		mode    => 0640,
		content => "NameVirtualHost *:5678
	Listen 5678
	<VirtualHost *:5678>
        ServerAdmin paul@mojo-projects.com
        ServerName pims2
        DocumentRoot /www/pims2/public
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory /www/pims2>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>
        <Directory /www/pims2/public>
                AllowOverride All
        </Directory>
        ErrorLog /var/log/apache2/pims2_error.log
        LogLevel warn
        CustomLog /var/log/apache2/pims2_access.log combined
</VirtualHost>",
}
