# default values are being ignored for now
define patterndb::simple::action::message (
  $values = {},
  $tags = [],
  $inherit_properties = false,
) {
  validate_bool($inherit_properties)
  validate_hash($values)
  validate_array($tags)
}
