require 'spec_helper'

describe 'openldap::service', :type => :class do

  it { should create_class('openldap::service') }
  it { should contain_service('slapd').with_ensure('running').with_enable('true') }

end

