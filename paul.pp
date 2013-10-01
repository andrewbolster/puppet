class paul {
	user { "paul":
		ensure=>present,
		managehome=>true,
		#Password for first login only, then changed.
		password => '$1$bjOk/WyV$LKPiyGzUhK.Sb0Ct2MEqM/',
		shell => '/bin/bash'
	}
	package { "vim": ensure => present }
}
include paul
