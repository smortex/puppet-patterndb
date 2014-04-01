# vim: ft=ruby:noexpandtab

class syslogng::pdb::update (
	$syslogng_modules = [],
	$test_before_deploy = true,
) {

	if ! defined(Class['Syslogng::Pdb']) {
		include syslogng::pdb
	}

	if ! defined(Exec['Syslogng::Pdb::Merge']) {
	if empty($syslogng_modules) {
		$modules = ""
	} else {
		$tmp = join($syslogng_modules," --module=")
		$modules = "--module=$tmp"
	}

	file { 'merged_and_deployed_pdb':
			path => "${::syslogng::base_dir}/var/lib/syslog-ng/patterndb.xml",
			ensure => "present"
	}

	exec { 'syslogng::pdb::merge':
			command => "pdbtool merge -r --glob \\*.pdb -D $::syslogng::pdb::pdb_dir -p ${::syslogng::temp_dir}/patterndb.xml",
			path => ["/bin", "/usr/bin" ],
			logoutput => true,
			refreshonly => true,
	}

	exec {'syslogng::pdb::test':
			#command  => "/usr/bin/pdbtool --validate test ${::syslogng::temp_dir}/patterndb.xml $modules",
			command  => "pdbtool test ${::syslogng::temp_dir}/patterndb.xml $modules",
			path => $::path,
			logoutput => true,
			refreshonly => true,
	}

	exec {'syslogng::pdb::deploy':
			command => "cp ${::syslogng::temp_dir}/patterndb.xml ${::syslogng::base_dir}/var/lib/syslog-ng/",
			path => $::path,
			logoutput => true,
			refreshonly => true
		}
	}

	if $test_before_deploy {
		File['merged_and_deployed_pdb'] ~> Exec['syslogng::pdb::merge'] ~> Exec['syslogng::pdb::test'] ~> Exec['syslogng::pdb::deploy']
	} else {
		File['merged_and_deployed_pdb'] ~> Exec['syslogng::pdb::merge'] ~>                                Exec['syslogng::pdb::deploy']
	}

}
