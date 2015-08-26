#
class { 'patterndb':
  manage_package => false,
  base_dir => '/tmp/'
}

Exec {
  path => ['/usr/local/bin','/usr/bin', '/bin']
}

patterndb::simple::ruleset { 'ruleset-a':
  id          => '99515b6c-2057-4232-b459-58ecaf2842bc',
  patterns    => [ 'a' ],
  pubdate     => '1985-01-01',
  rules       => {
    'id'      => 'MY_EMBEDDED_RULE_ID',
    'patterns' => 'abcde'
  }
}

patterndb::simple::action { 'myaction':
  rule     => 'MY_EMBEDDED_RULE_ID',
  message  => {
    values => {
      'a'  => 'b'
    },
    tags   => [ 'plop' ]
  },
}

patterndb::simple::rule { 'rule-a':
  ruleset   => 'ruleset-a',
  patterns  => ['match something else like @ESTRING:this: @dude'],
  ruleclass => 'ruleclass-a',
  examples => [
    {
      program => 'a',
      test_message => 'match something else like me dude',
      test_values => {
        'this' => 'me'
      }
    }
  ],
  actions   => [
    {
      message => {
        inherit_properties => true,
        values => {
          'foo' => 'bar'
        },
      }
    }
  ]
}

patterndb::simple::rule { 'rule-b':
  ruleset   => 'ruleset-a',
  patterns  => ['match even something else like @ESTRING:this: @dude'],
  ruleclass => 'ruleclass-b',
  examples => [
    {
      program => 'a',
      test_message => 'match even something else like me dude',
      test_values => {
        'this' => 'me'
      }
    }
  ]
}

patterndb::simple::action { 'alert_him':
  rule         => 'rule-b',
  message      => {
    values     => {
      'colour' => 'green'
    }
  }
}

patterndb::simple::action { 'alert_me':
  rule         => 'rule-b',
  message      => {
    values     => {
      'colour' => 'blue'
    }
  }
}
