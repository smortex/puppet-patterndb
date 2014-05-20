require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'   

PuppetLint.configuration.fail_on_warnings
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_arrow_alignment')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "tests/**/*.pp"]

task :default => [:spec, :lint]
