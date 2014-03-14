#
define syslogng::pdb::simple::rule (
	$id,
	$provider = "puppet",
	$class,
	$context_id = undef,
	$context_timeout = undef,
	$context_scope = undef,
	$patterns,
	$examples = [],
	$tags = [],
	$values = {},
){
	validate_string($id)
	validate_string($provider)
	validate_string($class)
	validate_string($context_id)
	validate_string($context_timeout)
	validate_string($context_scope)
	validate_array($patterns)
	validate_array($examples)
	validate_array($tags)
	validate_hash($values)
}

