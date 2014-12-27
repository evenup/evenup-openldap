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
# [*package_name*]
#   String.  Allows changing of the package name
#   Default: openldap-eu
#
# [*chkpass_pkg*]
#   String.  If set, name of the check-password package to install
#   Default: false
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
# [*chkpass_minpts*]
#   Integer.  Minimum number of quality points a new password must have
#   Default: 3
#
# [*chkpass_cracklib*]
#   Integer.  Set it to 0 to disable cracklib verification
#   Default: 1
#
# [*chkpass_minupper*]
#   Integer.  Minimum upper characters expected
#   Default: 0
#
# [*chkpass_minlower*]
#   Integer.  Minimum lower characters expected
#   Default: 0
#
# [*chkpass_mindigit*]
#   Integer.  Minimum digit characters expected
#   Default: 0
#
# [*chkpass_minpunct*]
#   Integer.  Minimum punctuation characters expected
#   Default: 0
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
class openldap(
  $package_name     = 'openldap-eu',
  $chkpass_pkg      = false,
  $ensure           = 'latest',
  $listen_ip        = '*',
  $tls_port         = 389,
  $ssl_port         = 636,
  $certfile         = '',
  $keyfile          = '',
  $base             = '',
  $uri              = '',
  $chkpass_minpts   = 3,
  $chkpass_cracklib = 1,
  $chkpass_minupper = 0,
  $chkpass_minlower = 0,
  $chkpass_mindigit = 0,
  $chkpass_minpunct = 0,
){

  class { 'openldap::install':
    ensure  => $ensure,
    package => $package_name,
    chkpass => $chkpass_pkg
  }

  class { 'openldap::config':
    listen_ip        => $listen_ip,
    tls_port         => $tls_port,
    ssl_port         => $ssl_port,
    certfile         => $certfile,
    keyfile          => $keyfile,
    base             => $base,
    uri              => $uri,
    chkpass          => $chkpass_pkg,
    chkpass_minpts   => $chkpass_minpts,
    chkpass_cracklib => $chkpass_cracklib,
    chkpass_minupper => $chkpass_minupper,
    chkpass_minlower => $chkpass_minlower,
    chkpass_mindigit => $chkpass_mindigit,
    chkpass_minpunct => $chkpass_minpunct,
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
