#
class { 'patterndb':
  base_dir => '/tmp/'
}

patterndb::simple::ruleset { 'dhclient':
  id       => 'ac5bfcf0-bfaa-4dc6-b064-e64700b50b75',
  pdb_name   => 'stage1',
  patterns => ['dhclient', 'dhcpclient'],
  pubdate  => '2014-03-14',
  rules => [
    {
      id => 'bd63010f-b339-4106-8ad3-4eb9764116b2',
      provider => 'me',
      patterns => [ 'DHCPACK from @IPv4::@' ],
      examples => [ { program => 'dhclient', test_message => 'DHCPACK from 172.17.0.1 (xid=0x245abdb1)'} ],
      tags => [ 'tagv1' ],
      ruleclass => 'system'
    }
  ]
}

patterndb::simple::ruleset { 'dhclient_fallback':
  id       => 'ac5bfcf0-bfaa-4dc6-b064-e64700b50b75',
  pdb_name   => 'stage2',
  patterns => ['dhclient', 'dhcpclient'],
  pubdate  => '2014-03-14',
  rules => [
    {
      id => '88298968-923e-4164-9e1f-f959ebbd43cd',
      provider => 'me',
      patterns => [ 'DHCPACK from @ANYSTRING@' ],
      examples => [ { program => 'dhclient', test_message => 'DHCPACK from FE80::0202:B3FF:FE1E:8329 (xid=0x245abdb1)'} ],
      tags => [ 'tagv1' ],
      ruleclass => 'system'
    }
  ]
}

