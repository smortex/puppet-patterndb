#
class { 'patterndb':
  base_dir         => '/tmp/',
  manage_package   => false,
  syslogng_modules => [],
  use_hiera        => true,
}

patterndb::parser { 'default': }

