#
class { "syslogng":
	base_dir => '/tmp/'
}

syslogng::pdb::raw::ruleset { 'raw':
	source => 'puppet:///modules/syslogng/tests/raw.pdb'
}

syslogng::pdb::raw::ruleset { 'raw.d':
	source => 'puppet:///modules/syslogng/tests/raw.d',
	ensure => 'directory'
}
