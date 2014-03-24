#
define syslogng::pdb::raw::ruleset (
	$source,
	$ensure = "present",
	$recurse = true,
	$purge = true,
	$sourceselect = "all",
	$ignore = [ ".svn", ".git" ],
)
{
	validate_string($source)
	validate_string($ensure)
	validate_string($sourceselect)
	validate_bool($recurse)

	if ! defined(Class['Syslogng::Pdb']) {
		include syslogng::pdb
	}

	if ! defined(Class['Syslogng::Pdb::Update']) {
		include syslogng::pdb::update
	}

	if $ensure == 'directory' {
		file { "${syslogng::pdb::pdb_dir}/${name}":
			ensure      => $ensure,
			recurse => $recurse,
			mode        => 0644,
			purge => $purge,
			source     => $source,
			sourceselect => $sourceselect,
			ignore => $ignore,
			notify      => Exec['syslogng::pdb::merge']
		}
	} else {
		file { "${syslogng::pdb::pdb_dir}/${name}.pdb":
			ensure      => $ensure,
			mode        => 0644,
			source     => $source,
			notify      => Exec['syslogng::pdb::merge']
		}
	}
}
