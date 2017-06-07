#
class patterndb (
  $base_dir = $::patterndb::defaults::base_dir,
  $temp_dir = $::patterndb::defaults::temp_dir,
  $package_name = false,
  $manage_package = true,
  $syslogng_modules = [],
  $use_hiera = false,
  $_manage_top_dirs = true,
  $test_before_deploy = true
) inherits patterndb::defaults {

  require stdlib
  validate_bool($manage_package)
  validate_bool($test_before_deploy)
  validate_array($syslogng_modules)
# package
  if $manage_package {
    if is_string($package_name) {
      $real_package_name = $package_name
    } else {
      case $::osfamily {
        'RedHat': { $real_package_name = 'syslog-ng' }
        'Debian': { $real_package_name = 'syslog-ng' }
        default: { fail("unsupported osfamily: ${::osfamily}") }
      }
    }
    ensure_resource ( 'package', $real_package_name, { 'ensure' => 'installed' })
  }
  ensure_resource ( 'file', $temp_dir, { ensure => directory } )
  if $_manage_top_dirs {
    ensure_resource ( 'file', "${base_dir}/etc", { ensure => 'directory' } )
    ensure_resource ( 'file', "${base_dir}/var", { ensure => 'directory' } )
    ensure_resource ( 'file', "${base_dir}/var/lib", { ensure => 'directory' } )
  }
  ensure_resource (
    'file', "${base_dir}/etc/syslog-ng",
    { ensure => 'directory' }
  )
  ensure_resource (
    'file', "${base_dir}/var/lib/syslog-ng",
    { ensure => 'directory' }
  )
  ensure_resource (
    'file', "${base_dir}/var/lib/syslog-ng/patterndb",
    {
      ensure => 'directory',
      purge => true,
      recurse => true
    }
  )
  $pdb_dir = "${base_dir}/etc/syslog-ng/patterndb.d"
  file { $pdb_dir:
    ensure  => directory,
    purge   => true,
    recurse => true,
    source  => 'puppet:///modules/patterndb/patterndb.d',
  }

  if $use_hiera {
    include patterndb::hiera
  }
}

