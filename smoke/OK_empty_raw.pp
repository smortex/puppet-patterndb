#
class { 'patterndb':
  base_dir => '/tmp/'
}

patterndb::raw::ruleset { 'raw':
  source => '/BLAH'
}
