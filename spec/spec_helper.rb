dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

require 'rubygems'
require 'rspec-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'

@common_specs = {}

@oses_specs = {

    'RedHat'            => @common_specs.merge({
        :operatingsystem            => 'RedHat',
        :osfamily                   => 'RedHat',

        :syslog_ng_package          => 'syslog-ng',
    }),

    'Debian'            => @common_specs.merge({
        :operatingsystem            => 'Debian',
        :osfamily                   => 'Debian',

        :syslog_ng_package          => 'syslog-ng',
    }),
}

