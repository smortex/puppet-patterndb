#
class { 'patterndb':
  base_dir => '/tmp/',
  syslogng_modules => [ 'tfgetent' ]
}

patterndb::simple::ruleset { 'getent':
  id       => 'ac5bfcf0-bfaa-ffc6-b064-e64700b50b75',
  pdb_name => 'default',
  patterns => ['A'],
  pubdate  => '2014-06-11',
  rules => [
    {
      id        => 'bd61010f-bff9-4106-8ad3-4eb9764116b2',
      provider  => 'me',
      patterns  => [ 'protocol: @NUMBER:proto_num@' ],
      ruleclass => 'system',
      values    => {
        'proto' => '$(getent protocols ${proto_num})'
      },
      examples  => [
        {
          program       => 'A',
          test_message  => 'protocol: 6',
          test_values   => {
            'proto_num' => '6',
            'proto'     => 'tcp'
          }
        }
      ]
    },
  ]
}

