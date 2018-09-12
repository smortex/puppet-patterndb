require 'spec_helper'

oses_specs = @oses_specs

describe 'patterndb', :type => 'class' do
  oses_specs.each do |osname, specs|
    context "#{osname} OS without package_name" do
      let :facts do {
          :osfamily        => specs[:osfamily],
          :operatingsystem => specs[:operatingsystem]
      }
      end
      it {
        should contain_package(specs[:syslog_ng_package])
      }
    end
    context "#{osname} OS without managing package" do
      let :params do
        { :manage_package => false }
      end
      it {
        should_not contain_package(specs[:syslog_ng_package])
      }
    end
  end
  context "Unsupported OS without package_name" do
    let :facts do
      { :osfamily => 'UnsupportedOne' }
    end
    it {
      expect {should raise_error(Puppet::Error)}
    }
  end
  context "Any OS with a package name" do
    let :params do
      { :package_name => 'othersyslogngpackagename' }
    end
    it {
      should contain_package('othersyslogngpackagename')
    }
  end
end
