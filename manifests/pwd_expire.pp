class openldap::pwd_expire(
  $uri                = 'ldap://localhost:389',
  $rootdn             = 'cn=Manager,dc=example,dc=com',
  $rootpw             = 'secret',
  $defaultpwdpolicydn = 'cn=default,ou=pwpolicies,dc=example,dc=com',
  $searchbase         = 'ou=people,dc=example,dc=com',
  $searchfilter       = '(&(uid=*)(objectClass=inetOrgPerson))',
  $searchscope        = 'one',
  $searchbin          = '/usr/bin/ldapsearch',
  $search_flags       = '-ZZ',
  $name_attr          = 'cn',
  $login_attr         = 'uid',
  $mail_attr          = 'mail',
  $mail_subject       = 'Your password is expiring soon',
  $mail_from          = 'support@example.com',
  $mail_body          = "%name - Please change your password\n\nThe LDAP team."
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
