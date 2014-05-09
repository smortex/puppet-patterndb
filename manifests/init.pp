#
class patterndb (
  $base_dir = $::patterndb::defaults::base_dir,
  $temp_dir = $::patterndb::defaults::temp_dir
) inherits patterndb::defaults {

  require stdlib
  ensure_resource('package', 'syslog-ng', { 'ensure' => 'present' })
  ensure_resource ( 'file', $temp_dir, { ensure => directory } )
  ensure_resource ( 'file', "${base_dir}/etc", { ensure => 'directory' } )
  ensure_resource (
    'file', "${base_dir}/etc/syslog-ng",
    { ensure => 'directory' }
  )
  ensure_resource ( 'file', "${base_dir}/var", { ensure => 'directory' } )
  ensure_resource ( 'file', "${base_dir}/var/lib", { ensure => 'directory' } )
  ensure_resource (
    'file', "${base_dir}/var/lib/syslog-ng",
    { ensure => 'directory' }
  )
  $pdb_dir = "${base_dir}/etc/syslog-ng/patterndb.d"
  file { $pdb_dir:
    ensure  => directory,
    purge   => true,
    recurse => true,
    source  => 'puppet:///modules/patterndb/patterndb.d',
  }

}

