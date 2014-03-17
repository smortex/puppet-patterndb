# vim: ft=ruby:noexpandtab

class syslogng::pdb::deploy (
) {

	if ! defined(Class['Syslogng::Pdb']) {
		include syslogng::pdb
	}

	ensure_resource ( 'exec', 'update-patterndb',
		{ 
			command => "/usr/bin/pdbtool merge -r --glob \\*.pdb -D $::syslogng::pdb::pdb_dir -p ${::syslogng::temp_dir}/patterndb.xml",
			logoutput => true,
			refreshonly => true,
			notify      => Exec['deploy-patterndb']
		}
	)

	ensure_resource ( 'exec', 'deploy-patterndb',
		{ 
			command => "/bin/cp ${::syslogng::temp_dir}/patterndb.xml ${::syslogng::base_dir}/var/lib/syslog-ng/",
			# pdbtool writes version 3 see bug on github
			#onlyif  => "/usr/bin/pdbtool --validate test ${::syslogng::temp_dir}/patterndb.xml",
			onlyif  => "/usr/bin/pdbtool test ${::syslogng::temp_dir}/patterndb.xml",
			logoutput => true,
			refreshonly => true
		}
	)

}
