What is it?
===========

A puppet module that installs OpenLDAP and manages the service.  It uses an RPM
based on the [LDAP Toolbox project's](http://www.ltb-project.org) RPM (included in the support directory) which
has been modified to install files in the typical RHEL paths.  This module
does not configure the directory itself (an exercise left to the user), but
instead focuses installing required files including certificates for SSL/TLS
that is left as an exercise to the user.

An additional class (openldap::pwd_expire) is available that installs a nightly
cron entry to check for users who's passwords are about to expire and emails
them a warning message.  This script requires using the ppolicy overlay for
password aging.


Usage:
------

Generic OpenLDAP install
<pre>
  class { 'openldap':
    base      => 'dc=mycompany,dc=com',
    certfile  => "puppet:///data/ssl/${::fqdn}.crt",
    keyfile   => "puppet:///data/ssl/${::fqdn}.key",

  }
</pre>

To use the check-password ppolicy module:
<pre>
  class { 'openldap':
    chkpass_pkg => openldap-eu-check-password
  }
</pre>
You will then need to modify your password policy entry by adding the
the objectClass pwdPolicyChecker and the attribute pwdCheckModule with a value
of check_password.so.

Setting up password expiration warning emails:
<pre>
  class { 'openldap::pwd_expire':
    uri         => 'ldap://ldap01.mycompany.com',
    rootdn      => 'cn=pwd_expire,ou=service_accounts,dc=mycompany,dc=com',
    rootpw      => 'mysecretpwd',
    searchbase  => 'ou=people,dc=mycompany,dc=com',
  }
</pre>


Known Issues:
-------------
Only tested on CentOS 6


License:
--------

Released under the Apache 2.0 licence


Contribute:
-----------
* Fork it
* Create a topic branch
* Improve/fix (with spec tests)
* Push new topic branch
* Submit a PR
