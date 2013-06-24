What is it?
===========

A puppet module that installs OpenLDAP and manages the service.  It uses an RPM
based on the [LDAP Toolbox project's](http://www.ltb-project.org) RPM (included in the support directory) which
has been modified to install files in the typical RHEL paths.  This module
does not configure the directory itself (an exercise left to the user), but
instead focuses installing required files including certificates for SSL/TLS
that is left as an exercise to the user.


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
