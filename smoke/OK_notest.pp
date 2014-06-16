#
class { 'patterndb':
  base_dir => '/tmp/',
  syslogng_modules => [ 'pdbtool_test_would_fail_with_this_module' ],
  test_before_deploy => false
}

patterndb::update { 'default':
  test_before_deploy => false
}

patterndb::simple::ruleset { 'someotherprogram':
  id => 'ac5bfcf0-bfaa-4dc6-b064-e647f0b50a75',
  patterns => ['dhclient', 'dhcpclient'],
  pubdate => '2014-03-14',
  rules => [
    {
      id => 'bd61010f-b339-9306-8ad5-4eb9764116b2',
      provider => 'me',
      patterns => [ 'DHCPACK from @IPv4::@' ],
      ruleclass => 'system',
    },
  ]
}

