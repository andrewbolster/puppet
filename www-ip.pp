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
	'ip':
		notify	=> Service["apache2"],
		path    => '/etc/apache2/sites-enabled/ip',
		ensure  => present,
		mode    => 0640,
		content => "NameVirtualHost *:80
	Listen 80
	<VirtualHost *:80>
        ServerAdmin webmaster@paulfreeman.me.uk
        ServerName pims2
        DocumentRoot /www/ip/public
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory /www/ip>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>
        <Directory /www/ip/public>
                AllowOverride All
        </Directory>
        ErrorLog /var/log/apache2/ip_error.log
        LogLevel warn
        CustomLog /var/log/apache2/ip_access.log combined
</VirtualHost>",
}
