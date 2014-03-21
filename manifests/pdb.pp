#
class syslogng::pdb () inherits ::syslogng::pdb::params {
    ensure_resource ( 'file', "$base_dir/etc", { ensure => 'directory' } )
    ensure_resource ( 'file', "$base_dir/etc/syslog-ng", { ensure => 'directory' } )
    $pdb_dir = "$base_dir/etc/syslog-ng/patterndb.d"
		file { $pdb_dir:
			ensure => directory,
			purge => true,
			recurse => true,
			source => "puppet:///modules/syslogng/patterndb.d",
		}
}
