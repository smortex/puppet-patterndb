require 'spec_helper'

describe 'patterndb::update', :type => 'class' do
  let :facts do {
    :osfamily => 'RedHat'
  } end
  context "Catchall" do
    it { should contain_class('Patterndb') }
    it { should contain_exec('patterndb::merge') }
    it { should contain_file('merged_and_deployed_pdb').with(
      'ensure' => 'present').that_notifies('Exec[patterndb::merge]')
    }
  end
  context "Default values (no parameters)" do
    let :params do {
      # noparams
    } end
    it {
      should contain_exec('patterndb::test').with(
        'command' => /patterndb.xml $/m
      )
    }
  end
  context "With syslog-ng module" do
    let :params do {
      :syslogng_modules => [ "foo","bar" ]
    } end
    it {
      should contain_exec('patterndb::test').with(
        'command' => /patterndb.xml --module=foo --module=bar$/m
      )
    }
  end
  context "With empty syslog-ng module list" do
    let :params do {
      :syslogng_modules => [ ]
    } end
    it {
      should contain_exec('patterndb::test').with(
        'command' => /patterndb.xml $/m
      )
    }
  end
  context "Without test_before_deploy" do
    let :params do {
      :test_before_deploy => false
    } end
    it { should contain_exec('patterndb::merge').that_notifies('Exec[patterndb::deploy]') }
  end
  context "With test_before_deploy" do
    let :params do {
      :test_before_deploy => true
    } end
    it { should contain_exec('patterndb::merge').that_notifies('Exec[patterndb::test]') }
    it { should contain_exec('patterndb::test').that_notifies('Exec[patterndb::deploy]') }
  end
end

