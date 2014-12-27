# == Class: openldap::config
#
# This class configures openldap.  It is not intended to be called directly.
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
class openldap::config (
  $listen_ip        = '*',
  $tls_port         = 389,
  $ssl_port         = 636,
  $certfile         = '',
  $keyfile          = '',
  $base             = '',
  $uri              = '',
  $chkpass          = false,
  $chkpass_minpts   = 3,
  $chkpass_cracklib = 1,
  $chkpass_minupper = 0,
  $chkpass_minlower = 0,
  $chkpass_mindigit = 0,
  $chkpass_minpunct = 0,
) {

  file { '/etc/default/slapd':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('openldap/slapd.erb'),
  }

  file { '/etc/openldap/ldap.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('openldap/ldap.conf.erb'),
  }

  file { '/etc/openldap/certs':
    ensure => 'directory',
    owner  => 'ldap',
    group  => 'ldap',
    mode   => '0770',
  }

  if $certfile != '' {
    file { '/etc/openldap/certs/ldap.pem':
      ensure => 'file',
      owner  => 'ldap',
      group  => 'ldap',
      mode   => '0444',
      source => $certfile,
    }
  }

  if $chkpass {
    file { '/etc/openldap/check_password.conf':
      ensure  => 'file',
      owner   => 'ldap',
      group   => 'ldap',
      mode    => '0440',
      content => template('openldap/check_password.conf.erb'),
    }
  }

  if $keyfile != '' {
    file { '/etc/openldap/certs/ldap.key':
      ensure => 'file',
      owner  => 'ldap',
      group  => 'ldap',
      mode   => '0440',
      source => $keyfile,
    }
  }
}
