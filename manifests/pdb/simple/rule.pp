# default values are being ignored for now
define syslogng::pdb::simple::rule (
	$id,
	$provider = "puppet",
	$ruleclass,
# currently ignored
	$context_id = undef,
	$context_timeout = undef,
	$context_scope = undef,
#
	$urls = [],
	$patterns,
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
}

