# vim: ft=ruby:noexpandtab

class syslogng::pdb::update (
) {

	if ! defined(Class['Syslogng::Pdb']) {
		include syslogng::pdb
	}

	ensure_resource ( 'exec', 'syslogng::pdb::merge',
		{ 
			command => "pdbtool merge -r --glob \\*.pdb -D $::syslogng::pdb::pdb_dir -p ${::syslogng::temp_dir}/patterndb.xml",
			path => [ "/usr/bin", "/bin" ],
			logoutput => true,
			refreshonly => true,
			notify      => Exec['syslogng::pdb::deploy']
		}
	)

	ensure_resource ( 'exec', 'syslogng::pdb::deploy',
		{ 
			command => "cp ${::syslogng::temp_dir}/patterndb.xml ${::syslogng::base_dir}/var/lib/syslog-ng/",
			path => [ "/usr/bin", "/bin" ],
			# pdbtool writes version 3 see bug on github
			#onlyif  => "/usr/bin/pdbtool --validate test ${::syslogng::temp_dir}/patterndb.xml",
			onlyif  => "pdbtool test ${::syslogng::temp_dir}/patterndb.xml",
			logoutput => true,
			refreshonly => true
		}
	)

}
