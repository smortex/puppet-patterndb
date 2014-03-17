#
define syslogng::pdb::raw (
	$source,
	$content,
)
{
	if ! defined(Class['Syslogng::Pdb']) {
		include syslogng::pdb
	}

	if ! defined(Class['Syslogng::Pdb::Deploy']) {
		include syslogng::pdb::deploy
	}

	$pdbfile = "${syslogng::pdb::pdb_dir}/${name}.pdb"
}
