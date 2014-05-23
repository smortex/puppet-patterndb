#
class { 'patterndb':
  base_dir => '/tmp/'
}

patterndb::simple::ruleset { 'dhclient':
  id => 'ac5bfcf0-bfaa-4dc6-b064-e64700b50b75',
  patterns => ['dhclient', 'dhcpclient'],
  pubdate => '2014-03-14',
  rules => [
    {
      id => 'bd63010f-b339-4106-8ad3-4eb9764116b2',
      provider => 'remi.ferrand@cc.in2p3.fr',
      patterns => [ 'DHCPACK from @IPv4::@' ],
      examples => [ { program => 'dhclient', test_message => 'DHCPACK from 172.17.0.1 (xid=0x245abdb1)'} ],
      tags => [ 'tagv1' ],
      ruleclass => 'system',
      urls => [ 'http://localhost/doc' ]
    },
    {
      id => '89e858cd-4bf6-4c1d-a092-41af271ef851',
      ruleclass => 'system',
      provider => 'me',
      patterns => [
        'match this @ANYSTRING@',
        'and that @ANYSTRING@'
      ],
      examples => [
        {
          program => 'dhcpclient',
          test_message => 'match this should match'
        },
        {
          program => 'dhcpclient',
          test_message => 'and that too'
        }
      ],
    }
  ]
}

patterndb::simple::ruleset { 'plop':
  id => 'plop',
  patterns => [ 'plop' ],
  pubdate => '1970-01-01',
  rules => [
    {
      id => 'plop',
      patterns => [ 'hello' ],
      values => {
        'plop' => 'ploup'
      },
    }
  ]
}

patterndb::simple::ruleset { 'a':
  id => 'a',
  patterns => [ 'a' ],
  pubdate => '1985-01-01',
  rules => [
    {
      id => 'b',
      patterns => ['match @ESTRING:this: @dude'],
      ruleclass => 'b',
      examples => [
        {
          program => 'a',
          test_message => 'match me dude',
          test_values => {
            'this' => 'me'
          }
        }
      ]
    }
  ]
}


