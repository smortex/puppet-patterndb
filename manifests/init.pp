#
class syslogng ( 
	$base_dir = $::syslogng::params::base_dir,
	$temp_dir = $::syslogng::params::temp_dir
) inherits ::syslogng::params {

    require stdlib
    ensure_resource('package', 'syslog-ng', { 'ensure' => 'present' })
    ensure_resource ( 'file', $base_dir, { ensure => directory } )
    ensure_resource ( 'file', $temp_dir, { ensure => directory } )

}
