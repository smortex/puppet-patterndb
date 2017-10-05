#
class patterndb::hiera (
  $prefix = 'patterndb'
)
{
  create_resources(
    'patterndb::parser',
    hiera_hash("${prefix}::parser", {})
  )
  create_resources(
    'patterndb::simple::ruleset',
    hiera_hash("${prefix}::ruleset",{})
  )
  create_resources(
    'patterndb::simple::rule',
    hiera_hash("${prefix}::rule", {})
  )
  create_resources(
    'patterndb::simple::action',
    hiera_hash("${prefix}::action", {})
  )
}
