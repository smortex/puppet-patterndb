#
class patterndb::update (
  $syslogng_modules = [],
  $test_before_deploy = true,
) {

  if ! defined(Class['Patterndb']) {
    include patterndb
  }

  if ! defined(Exec['Patterndb::Merge']) {
    if empty($syslogng_modules) {
      $modules = ''
      } else {
        $tmp = join($syslogng_modules,' --module=')
        $modules = "--module=${tmp}"
      }

      file { 'merged_and_deployed_pdb':
        ensure => present,
        path => "${::patterndb::base_dir}/var/lib/syslog-ng/patterndb.xml",
      }

      exec { 'patterndb::merge':
        command => "pdbtool merge -r --glob \\*.pdb -D ${::patterndb::pdb_dir} -p ${::patterndb::temp_dir}/patterndb.xml",
        path => $::path,
        logoutput => true,
        refreshonly => true,
      }

      exec {'patterndb::test':
        #command  => "/usr/bin/pdbtool --validate test ${::patterndb::temp_dir}/patterndb.xml $modules",
        command  => "pdbtool test ${::patterndb::temp_dir}/patterndb.xml ${modules}",
        path => $::path,
        logoutput => true,
        refreshonly => true,
      }

      exec {'patterndb::deploy':
        command => "cp ${::patterndb::temp_dir}/patterndb.xml ${::patterndb::base_dir}/var/lib/syslog-ng/",
        path => $::path,
        logoutput => true,
        refreshonly => true
      }
  }

  if $test_before_deploy {
    File['merged_and_deployed_pdb'] ~> Exec['patterndb::merge'] ~> Exec['patterndb::test'] ~> Exec['patterndb::deploy']
    } else {
      File['merged_and_deployed_pdb'] ~> Exec['patterndb::merge'] ~>                                Exec['patterndb::deploy']
    }

}
