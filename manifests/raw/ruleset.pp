#
define patterndb::raw::ruleset (
  $source,
  $ensure = 'present',
  $recurse = true,
  $purge = true,
  $sourceselect = 'all',
  $parser = 'default',
  $ignore = [ '.svn', '.git' ],
)
{
  validate_string($source)
  validate_string($parser)
  validate_string($ensure)
  validate_string($sourceselect)
  validate_bool($recurse)

  if ! defined(Class['Patterndb']) {
    include patterndb
  }

  if ! defined(Patterndb::Parser[$parser]) {
    patterndb::parser { $parser:
      test_before_deploy => $::patterndb::test_before_deploy,
      syslogng_modules   => $::patterndb::syslogng_modules,
    }
  }

  if $ensure == 'directory' {
    file { "${patterndb::pdb_dir}/${parser}/${name}":
      ensure       => $ensure,
      recurse      => $recurse,
      mode         => '0644',
      purge        => $purge,
      source       => $source,
      sourceselect => $sourceselect,
      ignore       => $ignore,
      notify       => Exec["patterndb::merge::${parser}"],
    }
  } else {
    file { "${patterndb::pdb_dir}/${parser}/${name}.pdb":
      ensure => $ensure,
      mode   => '0644',
      source => $source,
      notify => Exec["patterndb::merge::${parser}"],
    }
  }
}
