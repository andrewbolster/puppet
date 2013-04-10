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

class jenkins 
{
	apt::key { 'jenkins-ci.org.key':
		ensure => present,
		apt_key_url => 'http://pkg.jenkins-ci.org/debian'
	}
	line { "jenkins-source":
		require => Apt::Key['jenkins-ci.org.key'],
		file => '/etc/apt/sources.list',
		line => 'deb http://pkg.jenkins-ci.org/debian binary/'
	}
	exec { "/usr/bin/apt-get update":
		require => [ Line['jenkins-source'] ]
	}
	package { "jenkins":
		require => Exec['/usr/bin/apt-get update'],
		ensure => present,
	}
	package { "xvfb": ensure => present, }
	#
	# Must add used to admin/sudo no password group
	#
}
include jenkins