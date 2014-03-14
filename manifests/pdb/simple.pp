# vim: tabstop=4 shiftwidth=4 softtabstop=4

define syslogng::pdb::simple(
    $rule_id,
    $ruleset_id,
    $program_names,
    $provider,
    $patterns,
    $examples,
    $tags           = [],
    $url            = undef,
) {

    if ! defined(Class['Syslogng::Pdb']) {
        include syslogng::pdb
    }

    validate_array($program_names)
    validate_array($patterns)
    validate_array($examples)
    validate_array($tags)
    validate_string($url)
    validate_string($rule_id)
    validate_string($ruleset_id)
    validate_string($provider)

    $pdb_file = "${syslogng::pdb::pdb_dir}/${name}.pdb"

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
			command => "/bin/cp ${::syslogng::temp_dir}/patterndb.xml /var/lib/syslog-ng/",
			onlyif  => "/usr/bin/pdbtool --validate test ${::syslogng::temp_dir}/patterndb.xml",
			logoutput => true,
			refreshonly => true
		}
	)

    file {$pdb_file:
        ensure      => present,
        #owner       => 'root',
        #group       => 'root',
        mode        => 0644,
        content     => template('syslogng/pdb/simple.pdb.erb'),
        notify      => Exec['update-patterndb']
    }
}
