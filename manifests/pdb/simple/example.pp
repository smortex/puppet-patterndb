# default values are being ignored for now
define syslogng::pdb::simple::example (
	$program,
	$test_message,
	$test_values = {},
){
	validate_string($program)
	validate_string($test_message)
	validate_hash($test_values)
}

