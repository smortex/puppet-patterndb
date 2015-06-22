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
  $order = '00',
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
  unless (is_string($context_timeout) or is_integer($context_timeout)) {
    fail('context_timeout must be integer(ish)')
  }
  validate_string($context_scope)
  $patterns_a = string2array($patterns)
  $urls_a = string2array($urls)
  $examples_a = string2array($examples)
  $tags_a = string2array($tags)
  $actions_a = string2array($actions)
  validate_hash($values)

# validate sample messages
  patterndb_simple_example ( $examples_a, $id )
  if (! $_embedded) { # we were defined outside the ruleset
    if (! defined(Patterndb::Simple::Ruleset[$ruleset])) {
      fail("Failed while trying to define rule `${title}` for undeclared ruleset `${ruleset}`")
    }
  }
  # header
  concat::fragment { "patterndb_simple_rule-${title}-header":
    target  => "patterndb_simple_ruleset-${ruleset}",
    content => template('patterndb/rule-header.erb'),
    order   => "002-${order}-${title}-001",
  }
  # import embedded actions
  patterndb_simple_action ( $actions_a, $id, $order )
  # footer
  concat::fragment { "patterndb_simple_rule-${title}-footer":
    target  => "patterndb_simple_ruleset-${ruleset}",
    content => template('patterndb/rule-footer.erb'),
    order   => "002-${order}-${title}-zzz",
  }
}

