#
class { 'patterndb':
  manage_package => false,
  base_dir       => '/tmp/'
}

Patterndb::Simple::Rule  {
  provider => 'blah'
}

patterndb::simple::ruleset { 'a':
  id       => 'a',
  patterns => [ 'a' ],
  pubdate  => '1985-01-01',
  rules    => [
    {
      id        => 'b',
      patterns  => ['match @ESTRING:this: @dude'],
      ruleclass => 'b',
      examples  => [
        {
          program      => 'a',
          test_message => 'match me dude',
          test_values  => {
            'this' => 'me'
          }
        }
      ]
    }
  ]
}


