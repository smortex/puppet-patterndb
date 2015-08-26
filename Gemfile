# -*- encoding : utf-8 -*-
if RUBY_VERSION =~ /1.9/
    Encoding.default_external = Encoding::UTF_8
    Encoding.default_internal = Encoding::UTF_8
end

source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :development, :test do
    gem 'rake', '10.1.1',          :require => false
    gem 'rspec', '< 3.0'
    # Latest rspec-puppet is required for coverage
    gem 'rspec-puppet',            :git => 'https://github.com/rodjek/rspec-puppet.git'
    gem 'puppetlabs_spec_helper',  :require => false
    # Latest puppet-lint required for ignore paths to work
    gem 'puppet-lint',             :git => 'https://github.com/rodjek/puppet-lint.git'
end

if facterversion = ENV['FACTER_GEM_VERSION']
    gem 'facter', facterversion, :require => false
else
    gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
    gem 'puppet', puppetversion, :require => false
else
    gem 'puppet', :require => false
end

# vim:ft=ruby tabstop=4 shiftwidth=4 softtabstop=4
