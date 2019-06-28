#
class { 'patterndb':
  manage_package => false,
  base_dir       => '/tmp/',
}

patterndb::simple::ruleset { 'plop':
  id       => 'plop',
  patterns => 'plop',
  pubdate  => '1970-01-01',
  rules    => [
    {
      id       => 'plop',
      patterns => [ 'hello' ],
      values   => {
        'plop' => 'ploup',
      },
    },{
      id       => 'plop2',
      patterns => 'hollo',
    }
  ],
}

patterndb::simple::ruleset { 'a':
  id       => 'a',
  patterns => [ 'a' ],
  pubdate  => '1985-01-01',
  rules    => {
    id        => 'b',
    patterns  => ['match @ESTRING:this: @dude'],
    ruleclass => 'b',
    examples  => [
      {
        program      => 'a',
        test_message => 'match me dude',
        test_values  => {
          'this' => 'me',
        }
      },
    ],
  },
}

patterndb::simple::rule { 'rule-a':
  ruleset  => 'a',
  patterns => 'please match me',
  examples => [
    {
      program      => 'a',
      test_message => 'please match me',
    },
  ],
}

