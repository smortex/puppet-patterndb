# default values are being ignored for now
define patterndb::simple::action::message (
  $values = undef,
  $tags = undef,
  $inherit_properties = undef,
) {
  validate_bool($inherit_properties)
  validate_hash($values)
  validate_array($tags)
}
