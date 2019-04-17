#
class { 'patterndb':
  manage_package => false,
  base_dir       => '/tmp/'
}

patterndb::simple::ruleset { 'empty_ruleset':
  patterns => 'a',
  pubdate  => '1970-01-01'
}

patterndb::simple::ruleset { 'ruleset-a':
  id       => '99515b6c-2057-4232-b459-58ecaf2842bc',
  patterns => [ 'a' ],
  pubdate  => '1985-01-01',
}

patterndb::simple::ruleset { 'e3fea98a-6275-4a4a-990a-248f3f8ea8f6':
  patterns => 'x',
  pubdate  => '2014-08-11'
}

patterndb::simple::rule { 'x':
  ruleset   => 'e3fea98a-6275-4a4a-990a-248f3f8ea8f6',
  patterns  => ['match something else like @ESTRING:this: @dude'],
  ruleclass => 'b',
  examples  => [
    {
      program      => 'x',
      test_message => 'match something else like me dude',
      test_values  => {
        'this' => 'me'
      }
    }
  ]
}

patterndb::simple::rule { 'a':
  ruleset   => 'ruleset-a',
  patterns  => ['match something else like @ESTRING:this: @dude'],
  ruleclass => 'b',
  examples  => [
    {
      program      => 'a',
      test_message => 'match something else like me dude',
      test_values  => {
        'this' => 'me'
      }
    }
  ]
}

patterndb::simple::rule { 'b':
  ruleset  => 'ruleset-a',
  id       => '88d82bea-2d2e-479b-9e71-a832e3c1b790',
  patterns => ['match @ESTRING:this: @dude'],
  examples => [
    {
      program      => 'a',
      test_message => 'match me dude',
      test_values  => {
        'this' => 'me'
      }
    }
  ]
}

patterndb::simple::rule { 'c':
  ruleset  => 'ruleset-a',
  id       => '6a3e9d97-9902-4fbd-9bd6-a2c2d1036dee',
  patterns => ['match even another @ESTRING:this: @dude'],
  examples => [
    {
      program      => 'a',
      test_message => 'match even another me dude',
      test_values  => {
        'this' => 'me'
      }
    }
  ]
}
