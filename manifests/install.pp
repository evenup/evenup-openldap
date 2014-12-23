# == Class: openldap::install
#
# This class installs openldap.  It is not intended to be called directly.
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
#
# === Copyright
#
# Copyright 2013 EvenUp.
#
class openldap::install (
  $ensure   = 'latest',
  $package  = 'openldap-eu',
  $chkpass  = false,
){

  user { 'ldap':
    ensure  => 'present',
    system  => true,
    gid     => 'ldap',
    comment => 'LDAP service user',
    home    => '/var/lib/ldap',
    shell   => '/sbin/nologin',
  }

  group { 'ldap':
    ensure  => 'present',
    system  => true,
  }

  package { $package:
    ensure  => $ensure,
    notify  => Class['openldap::service'],
    require => [ User['ldap'], Group['ldap'] ],
  }

  if $chkpass {
    package { $chkpass:
      ensure  => 'latest',
      require => Package[$package],
    }
  }

  file { '/etc/openldap/slapd.conf':
    ensure  => 'absent',
    require => Package[$package]
  }

  file { '/etc/openldap/slapd.d':
    ensure  => 'directory',
    owner   => 'ldap',
    group   => 'ldap',
    mode    => '0770',
    require => Package[$package]
  }

}
