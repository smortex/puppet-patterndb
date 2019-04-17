require 'spec_helper'

describe 'patterndb', type: 'class' do
  on_supported_os.each do |os, facts|
    context "#{os} without package_name" do
      let (:facts) { facts }

      it { is_expected.to compile.with_all_deps }
      case facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_package('syslog-ng-core') }
      when 'RedHat'
        it { is_expected.to contain_package('syslog-ng') }
      end
    end
    context "#{os} OS without managing package" do
      let (:facts) { facts }
      let :params do
        { manage_package: false }
      end

      case facts[:osfamily]
      when 'Debian'
        it { is_expected.not_to contain_package('syslog-ng-core') }
      when 'RedHat'
        it { is_expected.not_to contain_package('syslog-ng') }
      end
    end
  end
  context 'Unsupported OS without package_name' do
    let :facts do
      { osfamily: 'UnsupportedOne' }
    end

    it { expect { is_expected.to raise_error(Puppet::Error) } }
  end
  context 'Any OS with a package name' do
    let :params do
      { package_name: 'othersyslogngpackagename' }
    end

    it { is_expected.to contain_package('othersyslogngpackagename') }
  end
end
