#
class { 'patterndb':
  manage_package => false,
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
      context_id      => 'blah',
      context_timeout => '10',
      examples => [
        {
          test_message => 'match this thing',
          program      => 'dhcpclient',
        }
      ],
      actions => [
        {
          trigger   => 'timeout',
          rate      => '1/60',
          condition => '"2" > "1"',
          message              => {
            inherit_properties => true,
            values             => {
              'MESSAGE'          => 'this is a patterdb generated message',
            },
            tags => [ 'pdb.action' ],
          },
        },
        {
          message              => {
            values             => {
              'MESSAGE'          => 'this is another patterdb generated message',
            },
            tags => [ 'a', 'b' ],
          },
        },
      ],
    }
  ]
}

