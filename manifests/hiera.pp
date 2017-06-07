#
class patterndb::hiera (
  $prefix = 'patterndb'
)
{
  create_resources(
    'patterndb::parser',
    hiera("${prefix}::parser", {})
  )
  create_resources(                                                                       'patterndb::simple::ruleset',
    hiera("${prefix}::ruleset",{})
  )
  create_resources(
    'patterndb::simple::rule',
    hiera("${prefix}::rule", {})
  )
  create_resources(
    'patterndb::simple::action',
    hiera("${prefix}::action", {})
  )
}
