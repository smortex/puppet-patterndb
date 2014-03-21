#
define syslogng::pdb::raw (
	$source,
	$content,
)
{
	if ! defined(Class['Syslogng::Pdb']) {
		include syslogng::pdb
	}

	if ! defined(Class['Syslogng::Pdb::Update']) {
		include syslogng::pdb::update
	}

	$pdbfile = "${syslogng::pdb::pdb_dir}/${name}.pdb"
}
