# == Class: openldap::pwd_expire
#
# This class installs a shell script from the LTB project to check and notify
# users who's password is about to expire.  It requires you are using the
# ppolicy overlay for password aging and runs nightly from cron.
#
#
# === Parameters
#
# [*uri*]
#   String.  LDAP URI to connect to
#   Default: ldap://localhost:389
#
# [*rootdn*]
#   String.  root DN (or other user's DN) to connect as
#   Default: cn=Manager,dc=example,dc=com'
#
# [*rootpw*]
#   String.  Password for the rootdn user
#   Default: secret
#
# [*defatpwdpolicydn*]
#   String.  DN of the default ppolicy object
#   Default: cn=default,ou=pwpolicies,dc=example,dc=com
#
# [*searchbase*]
#   String.  OU to search for users
#   Default: ou=people,dc=example,dc=com
#
# [*searchfilter*]
#   String.  Search filter to apply when looking for users
#   Default:  (&(uid=*)(objectClass=inetOrgPerson))
#
# [*searchscope*]
#   String.  Search scope
#   Default:  one
#
# [*searchbin*]
#   String.  Path to the ldapsearch binary
#   Default:  /usr/bin/ldapsearch
#
# [*searchflags*]
#   String.  Additional parameters to append to ldapsearch
#   Default: -ZZ
#
# [*name_attr*]
#   String.  Attribute containing the user's full name
#   Default: cn
#
# [*login_attr*]
#   String.  Attribute containing the user's username
#   Default: uid
#
# [*mail_attr*]
#   String.  Attribute containing the user's email address
#   Default: mail
#
# [*mail_suject*]
#   String. Subject for the warning email
#   Default: Your password is expiring soon
#
# [*mail_from*]
#   String.  Reply-to address for warning emails
#   Default:  support@example.com
#
# [*mail_body*]
#   String.  Body of the email message to send to the user
#   Default: "%name - Please change your password by logging into a host and typing passwd.
# === Examples
#
#   class { 'openldap::pwd_expire':
#     uri         => 'ldap://ldap01.mycompany.com',
#     rootdn      => 'cn=pwd_expire,ou=service_accounts,dc=mycompany,dc=com',
#     rootpw      => 'mysecretpwd',
#     searchbase  => 'ou=people,dc=mycompany,dc=com',
#   }
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
class openldap::pwd_expire(
  $uri                = 'ldap://localhost:389',
  $rootdn             = 'cn=Manager,dc=example,dc=com',
  $rootpw             = 'secret',
  $defaultpwdpolicydn = 'cn=default,ou=pwpolicies,dc=example,dc=com',
  $searchbase         = 'ou=people,dc=example,dc=com',
  $searchfilter       = '(&(uid=*)(objectClass=inetOrgPerson))',
  $searchscope        = 'one',
  $searchbin          = '/usr/bin/ldapsearch',
  $searchflags       = '-ZZ',
  $name_attr          = 'cn',
  $login_attr         = 'uid',
  $mail_attr          = 'mail',
  $mail_subject       = 'Your password is expiring soon',
  $mail_from          = 'support@example.com',
  $mail_body          = "%name - Please change your password by logging into a host and typing passwd."
) {

  package { 'mailx':
    ensure  => 'installed',
  }

  file { '/usr/local/bin/checkLdapPwdExpiration.sh':
    ensure  => 'file',
    mode    => '0550',
    owner   => 'root',
    group   => 'root',
    content => template('openldap/checkLdapPwdExpiration.sh.erb'),
  }

  cron { 'pwd_expire':
    command => '/usr/local/bin/checkLdapPwdExpiration.sh',
    user    => 'root',
    hour    => '11',
    minute  => '20',
  }

}
