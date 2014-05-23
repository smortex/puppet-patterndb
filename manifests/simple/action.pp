# default values are being ignored for now
define patterndb::simple::action (
  $trigger = undef,
  $rate = undef,
  $condition = undef,
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
}
