require 'spec_helper'

describe 'openldap::config', :type => :class do
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }

  it { should create_class('openldap::config') }

  it { should contain_file('/etc/default/slapd') }
  it { should contain_file('/etc/openldap/ldap.conf') }
  it { should contain_file('/etc/openldap/certs') }
  it { should_not contain_backups__archive('openldap_backup') }
  it { should contain_cron('openldap_backup').with_ensure('absent') }
  it { should contain_cron('openldap_backupconfig').with_ensure('absent') }

  context 'with certfile' do
    let(:params) { { :certfile => 'puppet:///modules/data/mycert.pem' } }

    it { should contain_file('/etc/openldap/certs/ldap.pem').with_source('puppet:///modules/data/mycert.pem') }
  end

  context 'with keyfile' do
    let(:params) { { :keyfile => 'puppet:///modules/data/mycert.key' } }

    it { should contain_file('/etc/openldap/certs/ldap.key').with_source('puppet:///modules/data/mycert.key') }
  end

  context 'with check-password' do
    let(:params) { { :chkpass => 'openldap-eu-check-password' } }
    it { should contain_file('/etc/openldap/check_password.conf') }
  end

  context 'with backups' do
    let(:params) { { :backups => true } }

    it { should contain_backups__archive('openldap_backup') }
    it { should contain_cron('openldap_backup').with_ensure('present') }
    it { should contain_cron('openldap_backupconfig').with_ensure('present') }
  end


end

