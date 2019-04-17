#
class { 'patterndb':
  base_dir         => '/tmp/',
  manage_package   => false,
  syslogng_modules => [],
  use_hiera        => true,
}

patterndb::parser { 'default': }

lookup(
  'my::patterndb::simple::ruleset',
  Hash,
  deep,
  {}
).each |$reference, $params| {
  notify { "ruleset ${reference}": }
  patterndb::simple::ruleset { $reference:
    * => $params
  }
}
lookup(
  'my::patterndb::simple::rule',
  Hash,
  deep,
  {}
).each |$reference, $params| {
  notify { "rule ${reference}": }
  patterndb::simple::rule { $reference:
    * => $params
  }
}
lookup(
  'my::patterndb::simple::action',
  Hash,
  deep,
  {}
).each |$reference, $params| {
  notify { "action ${reference}": }
  patterndb::simple::action { $reference:
    * => $params
  }
}

