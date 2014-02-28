# vim: tabstop=4 shiftwidth=4 softtabstop=4

define syslog-ng::pdb::simple(
    $rule_id,
    $provider,
    $patterns,
    $examples,
    $tags           = [],
    $url            = undef,
) {

    validate_array($patterns)
    validate_array($examples)
    validate_array($tags)
    validate_string($url)
    validate_string($rule_id)
    validate_string($provider)


}
