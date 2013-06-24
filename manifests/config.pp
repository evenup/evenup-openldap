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
  $listen_ip    = '*',
  $tls_port     = 389,
  $ssl_port     = 636,
  $certfile     = '',
  $keyfile      = '',
  $base         = '',
  $uri          = '',
  $backups      = false,
) {

  $cron = $backups ? {
    /(true|True|'true')/  => 'present',
    default               => 'absent',
  }

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
    ensure  => 'directory',
    owner   => 'ldap',
    group   => 'ldap',
    mode    => '0770',
  }

  if $certfile != '' {
    file { '/etc/openldap/certs/ldap.pem':
      ensure  => 'file',
      owner   => 'ldap',
      group   => 'ldap',
      mode    => '0444',
      source  => $certfile,
    }
  }

  if $keyfile != '' {
    file { '/etc/openldap/certs/ldap.key':
      ensure  => 'file',
      owner   => 'ldap',
      group   => 'ldap',
      mode    => '0440',
      source  => $keyfile,
    }
  }

  if $backups {
    backups::archive { 'openldap_backup':
      path      => '/usr/var/save/',
      hour      => 7,
      minute    => 10,
      keep      => 30,
      tmp_path  => '/data/tmp';
    }
  }

  cron { 'openldap_backup':
    ensure  => $cron,
    command => '/etc/init.d/slapd backup',
    user    => 'root',
    hour    => '6',
    minute  => '50',
  }

  cron { 'openldap_backupconfig':
    ensure  => $cron,
    command => '/etc/init.d/slapd backupconfig',
    user    => 'root',
    hour    => '6',
    minute  => '55',
  }

}
