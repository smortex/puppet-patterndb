#
define patterndb::raw::ruleset (
  $source,
  $ensure = 'present',
  $recurse = true,
  $purge = true,
  $sourceselect = 'all',
  $pdb_name = 'default',
  $ignore = [ '.svn', '.git' ],
)
{
  validate_string($source)
  validate_string($pdb_name)
  validate_string($ensure)
  validate_string($sourceselect)
  validate_bool($recurse)

  if ! defined(Class['Patterndb']) {
    include patterndb
  }

  if ! defined(Patterndb::Update[$pdb_name]) {
    patterndb::update { $pdb_name: }
  }

  if $ensure == 'directory' {
    file { "${patterndb::pdb_dir}/${pdb_name}/${name}":
      ensure      => $ensure,
      recurse => $recurse,
      mode        => '0644',
      purge => $purge,
      source     => $source,
      sourceselect => $sourceselect,
      ignore => $ignore,
      notify      => Exec["patterndb::merge::${pdb_name}"]
    }
  } else {
    file { "${patterndb::pdb_dir}/${pdb_name}/${name}.pdb":
      ensure      => $ensure,
      mode        => '0644',
      source     => $source,
      notify      => Exec["patterndb::merge::${pdb_name}"]
    }
  }
}
