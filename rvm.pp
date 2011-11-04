import "rvm"
include rvm::system

user
{
	paul:
		home => '/home/paul'
} 

rvm::system_user { paul: ; }

if $rvm_installed == "true" {
  rvm_system_ruby {
    'ruby-1.9.2-p290':
      ensure => 'present',
      default_use => true;
    'ruby-1.8.7-p334':
      ensure => 'present',
      default_use => false;
  }
}

if $rvm_installed == "true" {
    rvm_gemset {
      "ruby-1.9.2-p290@myproject":
        ensure => present,
        require => Rvm_system_ruby['ruby-1.9.2-p290'];
    }
}

