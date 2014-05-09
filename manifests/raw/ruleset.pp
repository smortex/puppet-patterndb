#
define patterndb::raw::ruleset (
  $source,
  $ensure = 'present',
  $recurse = true,
  $purge = true,
  $sourceselect = 'all',
  $ignore = [ '.svn', '.git' ],
)
{
  validate_string($source)
  validate_string($ensure)
  validate_string($sourceselect)
  validate_bool($recurse)

  if ! defined(Class['Patterndb']) {
    include patterndb
  }

  if ! defined(Class['Patterndb::Update']) {
    include patterndb::update
  }

  if $ensure == 'directory' {
    file { "${patterndb::pdb_dir}/${name}":
      ensure      => $ensure,
      recurse => $recurse,
      mode        => '0644',
      purge => $purge,
      source     => $source,
      sourceselect => $sourceselect,
      ignore => $ignore,
      notify      => Exec['patterndb::merge']
    }
  } else {
    file { "${patterndb::pdb_dir}/${name}.pdb":
      ensure      => $ensure,
      mode        => '0644',
      source     => $source,
      notify      => Exec['patterndb::merge']
    }
  }
}
