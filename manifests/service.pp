# == Class: openldap::service
#
# This class manages the openldap service.  It is not intended to be called directly.
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
class openldap::service (
) {

  service { 'slapd':
    ensure => 'running',
    enable => true,
  }

}
