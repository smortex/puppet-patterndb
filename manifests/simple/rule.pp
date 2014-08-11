# default values are being ignored for now
define patterndb::simple::rule (
  $patterns,
  $ruleset,
  $id = $title,
  $provider = 'puppet',
  $ruleclass = 'system',
  $context_id = undef,
  $_embedded = false,
  $context_timeout = undef,
  $context_scope = undef,
  $actions = [],
# begin currently ignored
  $urls = [],
# end currently ignored
  $examples = [],
  $tags = [],
  $values = {},
){
  validate_string($id)
  validate_string($provider)
  validate_string($ruleclass)
  validate_string($context_id)
  validate_string($context_timeout)
  validate_string($context_scope)
  validate_array($patterns)
  validate_array($urls)
  validate_array($examples)
  validate_array($tags)
  validate_array($actions)
  validate_hash($values)

# validate sample messages
  patterndb_simple_example ( $examples, $id )
# validate actions
  patterndb_simple_action ( $actions, $id )
  if ($_embedded) { # we were defined from within the ruleset definition
    concat::fragment { "patterndb_simple_rule-${title}":
      target  => "patterndb_simple_ruleset-${ruleset}",
      content => template('patterndb/rule.erb'),
    }
  } else { # we were defined on our own
    if (defined(Patterndb::Simple::Ruleset[$ruleset])) {
      concat::fragment { "patterndb_simple_rule-${title}":
        target  => "patterndb_simple_ruleset-${ruleset}",
        content => template('patterndb/rule.erb'),
      }
    } else {
      fail("Failed while trying to define rule `${title}` for undeclared ruleset `${ruleset}`")
    }
  }
}

