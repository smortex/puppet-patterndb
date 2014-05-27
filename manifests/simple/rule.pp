# default values are being ignored for now
define patterndb::simple::rule (
  $id,
  $patterns,
  $provider = 'puppet',
  $ruleclass = 'system',
  $context_id = undef,
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
  patterndb_simple_example ($examples)
# validate actions
  patterndb_simple_action ( $actions, $id )
}

