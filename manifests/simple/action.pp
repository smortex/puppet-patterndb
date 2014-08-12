# default values are being ignored for now
define patterndb::simple::action (
  $rule,
  $trigger = undef,
  $rate = undef,
  $condition = undef,
  $_embedded = false,
  $rule_order = '00',
  $message = undef,
) {
  validate_string($trigger)
  if $trigger and ! ($trigger in ['match', 'timeout']) {
    fail("`${trigger}` is not a valid trigger parameter value")
  }
  validate_string($rate)
  validate_string($condition)
  validate_hash($message)
  patterndb_simple_action_message ($message, $name)
  if ($_embedded) { # we were defined outside the rule
    if (! defined(Patterndb::Simple::Rule[$rule])) {
      fail("Failed while trying to define action `${title}` for undeclared rule `${rule}`")
    }
  }
  $ruleset = getparam("Patterndb::Simple::Rule[${rule}]",'ruleset')
  concat::fragment { "patterndb_simple_rule-${rule}-${title}":
    target  => "patterndb_simple_ruleset-${ruleset}",
    content => template('patterndb/action.erb'),
    order   => "002-${rule_order}-${rule}-002",
  }
}
