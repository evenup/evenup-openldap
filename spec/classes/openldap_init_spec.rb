require 'spec_helper'

describe 'openldap', :type => :class do
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }

  it { should create_class('openldap') }

  it { should contain_class('openldap::install') }
  it { should contain_class('openldap::config') }
  it { should contain_class('openldap::service') }

end

