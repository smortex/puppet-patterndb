#
class { 'patterndb':
  base_dir => '/tmp/',
  syslogng_modules => [ 'basicfuncs' ]
}

patterndb::simple::ruleset { 'someprogram':
  id => 'ac5bfcf0-bfaa-4dc6-b064-e64700b50b75',
  patterns => ['dhclient', 'dhcpclient'],
  pubdate => '2014-03-14',
  rules => [
    {
      id => 'bd61010f-b339-4106-8ad3-4eb9764116b2',
      provider => 'me',
      patterns => [ 'DHCPACK from @IPv4::@' ],
      ruleclass => 'system',
    },
  ]
}

