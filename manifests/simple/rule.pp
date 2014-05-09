# default values are being ignored for now
define patterndb::simple::rule (
  $id,
  $patterns,
  $provider = 'puppet',
  $ruleclass = 'system',
# begin currently ignored
  $context_id = undef,
  $context_timeout = undef,
  $context_scope = undef,
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
  validate_hash($values)

# validate sample messages
  patterndb_simple_example ($examples)
}

