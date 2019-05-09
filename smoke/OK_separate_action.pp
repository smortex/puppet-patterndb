#
class { 'patterndb':
  manage_package => false,
  base_dir       => '/tmp/'
}

Exec {
  path => ['/usr/local/bin','/usr/bin', '/bin']
}

patterndb::simple::ruleset { 'ruleset-a':
  id       => '99515b6c-2057-4232-b459-58ecaf2842bc',
  patterns => [ 'a' ],
  pubdate  => '1985-01-01',
  rules    => {
    'id'       => 'MY_EMBEDDED_RULE_ID',
    'patterns' => 'abcde'
  }
}

patterndb::simple::action { 'myaction':
  rule      => 'MY_EMBEDDED_RULE_ID',
  condition => '"a" > "4"',
  message   => {
    values => {
      'a'  => 'b'
    },
    tags   => [ 'plop' ]
  },
}

patterndb::simple::rule { 'MY_SEPARATE_RULE':
  ruleset  => 'ruleset-a',
  patterns => 'aaaaaa',
  actions  => [
    {
      rate    => '1/60',
      message => {
        values    => {
          message => 'plop'
        }
      },
    }
  ]
}
