# vim: ft=ruby:noexpandtab

class syslogng::pdb::update (
) {

	if ! defined(Class['Syslogng::Pdb']) {
		include syslogng::pdb
	}

	if ! defined(Exec['Syslogng::Pdb::Merge']) {
	exec { 'syslogng::pdb::merge':
			command => "pdbtool merge -r --glob \\*.pdb -D $::syslogng::pdb::pdb_dir -p ${::syslogng::temp_dir}/patterndb.xml",
			creates => "${::syslogng::temp_dir}/patterndb.xml",
			path => ["/bin", "/usr/bin" ],
			logoutput => true,
			refreshonly => true,
			notify      => Exec['syslogng::pdb::deploy']
		}

	exec {'syslogng::pdb::deploy':
			command => "cp ${::syslogng::temp_dir}/patterndb.xml ${::syslogng::base_dir}/var/lib/syslog-ng/",
			creates => "${::syslogng::base_dir}/var/lib/syslog-ng/patterndb.xml",
			path => [ "/bin", "/usr/bin" ],
			# pdbtool writes version 3 see bug on github
			#onlyif  => "/usr/bin/pdbtool --validate test ${::syslogng::temp_dir}/patterndb.xml",
			onlyif  => "pdbtool test ${::syslogng::temp_dir}/patterndb.xml",
			logoutput => true,
			refreshonly => true
		}
	}

}
