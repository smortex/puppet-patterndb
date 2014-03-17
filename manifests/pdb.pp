#
class syslogng::pdb () inherits ::syslogng::pdb::params {
    
    $pdb_dir = "$base_dir/etc/syslog-ng/patterndb.d"
		file { $pdb_dir:
			ensure => directory,
			purge => true,
			recurse => true,
			source => "puppet:///modules/syslogng/patterndb.d",
		}
}
