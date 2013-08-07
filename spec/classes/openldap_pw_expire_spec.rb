require 'spec_helper'

describe 'openldap::pwd_expire', :type => :class do
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }

  it { should create_class('openldap::pwd_expire') }
  it { should contain_package('mailx') }
  it { should contain_file('/usr/local/bin/checkLdapPwdExpiration.sh') }
  it { should contain_cron('pwd_expire') }

end

