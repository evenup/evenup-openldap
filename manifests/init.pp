# == Class: openldap
#
# This class installs openldap, does a very basic configuration, and manages
# the openldap service.  This module is intended to be used with a modified
# version of the LTB openldap package.  The spec file can be found in the
# support directory.
#
#
# === Parameters
#
# [*pachage_name*]
#   String.  Allows changing of the package name
#   Default: openldap-eu
#
# [*ensure*]
#   String.  What version to install.
#   Default: latest
#
# [*listen_ip*]
#   String.  Address OpenLDAP should listen on.  Note: if you are running
#     with syncrepl make sure this name matches one of the serverIds or ldap
#     will fail to start.
#   Default: *
#
# [*tls_port*]
#   Integer.  Port the unencrypted and TLS listener should listen on
#   Default: 389
#
# [*ssl_port*]
#   Integer.  Port the SSL listener should listen on
#   Default: 636
#
# [*certfile*]
#   String.  Path to the location of the certfile for this node
#   Default: ''
#
# [*keyfile*]
#   String.  Path to the location of the key file for this node
#   Default: ''
#
#
# === Examples
#
# * Installation:
#     class { 'openldap':
#       base  => 'dc=mycompany,dc=com'
#     }
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
class openldap(
  $package_name = 'openldap-eu',
  $ensure       = 'latest',
  $listen_ip    = '*',
  $tls_port     = 389,
  $ssl_port     = 636,
  $certfile     = '',
  $keyfile      = '',
  $base         = '',
  $uri          = '',
  $backups      = false,
){

  class { 'openldap::install':
    ensure  => $ensure,
    package => $package_name,
  }

  class { 'openldap::config':
    listen_ip => $listen_ip,
    tls_port  => $tls_port,
    ssl_port  => $ssl_port,
    certfile  => $certfile,
    keyfile   => $keyfile,
    base      => $base,
    uri       => $uri,
    backups   => $backups,
  }

  class { 'openldap::service': }

  # Containment
  anchor { 'openldap::begin': }
  anchor { 'openldap::end': }

  Anchor['openldap::begin'] ->
  Class['openldap::install'] ->
  Class['openldap::config'] ->
  Class['openldap::service'] ->
  Anchor['openldap::end']

}
