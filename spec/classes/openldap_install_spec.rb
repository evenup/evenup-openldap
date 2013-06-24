require 'spec_helper'

describe 'openldap::install', :type => :class do

  it { should create_class('openldap::install') }

  context 'default' do
    it { should contain_user('ldap') }
    it { should contain_group('ldap') }
    it { should contain_package('openldap-eu').with_ensure('latest') }
    it { should contain_file('/etc/openldap/slapd.conf').with_ensure('absent') }
    it { should contain_file('/etc/openldap/slapd.d') }
  end

  context 'package config' do
    let(:params) { { :package => 'openldap', :ensure => '2.4.23' } }
    it { should contain_package('openldap').with_ensure('2.4.23') }
  end

end

