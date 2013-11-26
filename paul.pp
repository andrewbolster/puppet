class paul {
  group { "admin": ensure => present }
  group { "www-data": ensure => present }
  group { "paul": ensure => present }
  user { "paul":
    ensure=>present,
    managehome=>true,
    #Password for first login only, then changed.
    password => '$1$bjOk/WyV$LKPiyGzUhK.Sb0Ct2MEqM/',
    groups => ["paul","www-data","admin"],
    shell => '/bin/bash',
    require => [ Group["admin"],Group["www-data"],Group["paul"] ]
  }
  package { "vim": ensure => present }
}
include paul