define apt::key($ensure, $apt_key_url = 'http://www.example.com/apt/keys') {
  case $ensure {
    'present': {
      exec { "apt-key present $name":
        command => "/usr/bin/wget -q $apt_key_url/$name -O -|/usr/bin/apt-key add -",
        unless  => "/usr/bin/apt-key list|/bin/grep -c $name",
      }
    }
    'absent': {
      exec { "apt-key absent $name":
        command => "/usr/bin/apt-key del $name",
        onlyif  => "/usr/bin/apt-key list|/bin/grep -c $name",
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for apt::key"
    }
  }
}

define line($file, $line, $ensure = 'present') {
    case $ensure {
        default : { err ( "unknown ensure value ${ensure}" ) }
        present: {
            exec { "/bin/echo '${line}' >> '${file}'":
                unless => "/bin/grep -qFx '${line}' '${file}'"
            }
        }
        absent: {
            exec { "/bin/grep -vFx '${line}' '${file}' | /usr/bin/tee '${file}' > /dev/null 2>&1":
              onlyif => "/bin/grep -qFx '${line}' '${file}'"
            }

            # Use this resource instead if your platform's grep doesn't support -vFx;
            # note that this command has been known to have problems with lines containing quotes.
            # exec { "/usr/bin/perl -ni -e 'print unless /^\\Q${line}\\E\$/' '${file}'":
            #     onlyif => "/bin/grep -qFx '${line}' '${file}'"
            # }
        }
    }
}

class nodestuff
{
	apt::key { 'linux_signing_key.pub':
		ensure => present,
		apt_key_url => 'https://dl-ssl.google.com/linux'
	}
	file { "/etc/apt/sources.list.d/google.list":
		content => 'deb http://dl.google.com/linux/chrome/deb/ stable main',
		require => Apt::Key["linux_signing_key.pub"]
	}
	exec { "/usr/bin/apt-get update":
		require => File['/etc/apt/sources.list.d/google.list']
	}
	package { "google-chrome-stable": ensure => present, require => Exec['/usr/bin/apt-get update'], }
	package { "vim": ensure => present, }
	package { "ufw": ensure => present, }
	package { "byobu": ensure => present, }
	package { "curl": ensure => present, }
	package { "git-core": ensure => present, }
	package { "libssl-dev": ensure => present, }

	package { "software-properties-common": ensure => present, }
	package { "python-software-properties": ensure => present, }
	package { "python": ensure => present, }
	package { "g++": ensure => present, }
	package { "make": ensure => present, }

	exec { "/usr/bin/add-apt-repository ppa:chris-lea/node.js": require => Package["software-properties-common"] }
	exec { "/usr/bin/apt-get update; echo ''":
		require => Exec['/usr/bin/add-apt-repository ppa:chris-lea/node.js']
	}
	package { "nodejs": ensure => present, require => Exec["/usr/bin/apt-get update; echo ''"], }
	package { "npm": ensure => present, require => Exec["/usr/bin/apt-get update; echo ''"], }

	package { "libxml2-dev": ensure => present, }

	package { "libreoffice": ensure => present, }


	line { "node_path":
		file => '/home/vagrant/.profile',
		line => 'export NODE_PATH=/usr/lib/node_modules/application-name/node_modules'
	}

	package { "xvfb": ensure => present, }
	package { "mongodb":
		ensure => installed,
	}
	service { "mongodb":
	    enable => true,
		ensure => running,
		require => Package["mongodb"],
	}	
}
include nodestuff