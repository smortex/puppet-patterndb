#
class { 'patterndb':
  base_dir => '/tmp/'
}

patterndb::raw::ruleset { 'raw':
  source => 'puppet:///modules/patterndb/tests/raw.pdb'
}

patterndb::raw::ruleset { 'raw.d':
  ensure => 'directory',
  source => 'puppet:///modules/patterndb/tests/raw.d',
}
