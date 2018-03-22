#
class { 'patterndb':
  base_dir       => '/tmp/',
  manage_package => false,
  syslogng_modules   => [],
}

Patterndb::Simple::Rule  {
  provider => 'blah'
}

patterndb::simple::ruleset { 'a':
  id => 'a',
  patterns => [ 'a' ],
  pubdate => '1985-01-01',
  rules => [
    {
      id        => 'b',
      patterns  => ['ma<>tch @ESTRING:this: @dude'],
      ruleclass => 'b',
      values    => {
        'foo'   => 1,
        'bar'   => 4,
      },
      examples => [
        {
          program => 'a',
          test_message => 'ma<>tch me dude',
          test_values => {
            'this' => 'me'
          }
        }
      ]
    }
  ]
}

create_resources('patterndb::simple::ruleset', hiera('patterndb::simple::ruleset',{},'patterndb'))
create_resources('patterndb::simple::rule', hiera('patterndb::simple::rule',{},'patterndb'))
#create_resources('patterndb::simple::action', hiera('patterndb::simple::action',{},'patterndb'))

