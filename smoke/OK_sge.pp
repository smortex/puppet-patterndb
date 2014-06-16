#
class { 'patterndb':
  base_dir => '/tmp',
  syslogng_modules => [ 'tfgeoip', 'tfgetent' ],
  test_before_deploy => true,
}
  patterndb::simple::ruleset { 'sge-query-command':
    id => '114705bd-827b-4033-988c-647314f78bac',
    patterns => [ 'sge-query-command' ],
    pubdate => '2014-03-28',
    rules => [
      {
        id => '92d54897-c959-4d0a-bef2-677312ffdda7',
        ruleclass => 'site.gridengine',
        patterns => [
          '@NUMBER:usracct.uid@:@NUMBER:usracct.gid@ @ESTRING:appacct.path:qstat@ @ESTRING:appacct.attrs:-j @@ANYSTRING:tmp.attrs_continued@',
        ],
        values => {
          'appacct.program' => 'qstat',
          'appacct.attrs' => '${appacct.attrs}-j ${tmp.attrs_continued}',
          'usracct.username' => '$(getent passwd ${usracct.uid})',
          'usracct.groupname' => '$(getent group ${usracct.gid})',
        },
        examples => [
          {
            program => 'sge-query-command',
            test_message => '0:0 qstat -f -j 43778',
            test_values => {
              'appacct.path' => '',
              'usracct.uid' => '0',
              'usracct.username' => 'root',
              'usracct.groupname' => 'root',
              'usracct.gid' => '0',
              'appacct.program' => 'qstat',
              'appacct.attrs' => '-f -j 43778',
            }
          },
          {
            program => 'sge-query-command',
            test_message => '21299:124 /opt/sge/bin/lx24-amd64/qstat -j 89257.1',
            test_values => {
              'appacct.path' => '/opt/sge/bin/lx24-amd64/',
              'usracct.uid' => '21299',
              'usracct.gid' => '124',
              'appacct.program' => 'qstat',
              'appacct.attrs' => '-j 89257.1',
            }
          },
        ],
      },
      {
        id => '2506d58f-b90b-4b8f-a8c5-41d6ee56ab02',
        ruleclass => 'site.gridengine',
        patterns => [
          '@NUMBER:usracct.uid@:@NUMBER:usracct.gid@ @ESTRING:appacct.path:qstat @@ANYSTRING:appacct.attrs@',
          '@NUMBER:usracct.uid@:@NUMBER:usracct.gid@ @ESTRING:appacct.path:qstat @',
        ],
        values => {
          'appacct.program' => 'qstat',
          'usracct.username' => '$(getent passwd ${usracct.uid})',
        },
        examples => [
          {
            program => 'sge-query-command',
            test_message => '41705:194 qstat ',
            test_values => {
              'appacct.attrs' => '',
              'appacct.path' => '',
              'appacct.program' => 'qstat',
            },
          },
          {
            program => 'sge-query-command',
            test_message => '55:55 /opt/sge/bin/lx-amd64/qstat -help ',
            test_values => {
              'appacct.attrs' => '-help ',
              'appacct.path' => '/opt/sge/bin/lx-amd64/',
              'appacct.program' => 'qstat',
            },
          }
        ],
      },
      {
        id => 'c1905e4b-d220-4a0e-8535-1fc662cddfd4',
        ruleclass => 'site.gridengine',
        patterns => [
          '@NUMBER:usracct.uid@:@NUMBER:usracct.gid@ @ESTRING:appacct.path:qstat@ @ESTRING:appacct.attrs:-u @@ANYSTRING:tmp.attrs_continued@',
        ],
        values => {
          'appacct.attrs' => '${appacct.attrs}-u ${tmp.attrs_continued}',
          'appacct.program' => 'qstat',
          'usracct.username' => '$(getent passwd ${usracct.uid})',
        },
        examples => [
          {
            program => 'sge-query-command',
            test_message => '55:55 /opt/sge/bin/lx-amd64/qstat -xml -f -u * -r -F s_cpu,num_procs,h_rt,slots,h_cpu,s_rt',
            test_values => {
              'usracct.uid' => '55',
              'usracct.gid' => '55',
              'appacct.path' => '/opt/sge/bin/lx-amd64/',
              'appacct.program' => 'qstat',
              'appacct.attrs' => '-xml -f -u * -r -F s_cpu,num_procs,h_rt,slots,h_cpu,s_rt',
            }
          },
          {
            program => 'sge-query-command',
            test_message => '91:91 /opt/sge/bin/lx24-amd64/qstat -u * ',
            test_values => {
              'usracct.uid' => '91',
              'usracct.gid' => '91',
              'appacct.path' => '/opt/sge/bin/lx24-amd64/',
              'appacct.program' => 'qstat',
              'appacct.attrs' => '-u * ',
            }
          },
          {
            program => 'sge-query-command',
            test_message => '2702:188 qstat -xml -u snprod ',
            test_values => {
              'usracct.uid' => '2702',
              'usracct.gid' => '188',
              'appacct.path' => '',
              'appacct.program' => 'qstat',
              'appacct.attrs' => '-xml -u snprod ',
            }
          },
        ]
      },
      {
        id => '7d18145b-7070-4fae-bf9a-2311f1cd843a',
        ruleclass => 'site.gridengine',
        patterns => [
          '@NUMBER:usracct.uid@:@NUMBER:usracct.gid@ @ESTRING:appacct.path:qacct @@ANYSTRING:appacct.attrs@',
          '@NUMBER:usracct.uid@:@NUMBER:usracct.gid@ @ESTRING:appacct.path:qacct @',
        ],
        values => {
          'appacct.program' => 'qacct',
          'usracct.username' => '$(getent passwd ${usracct.uid})',
        },
        examples => [
          {
            program => 'sge-query-command',
            test_message => '91:91 /opt/sge/bin/lx24-amd64/qacct -j 122483 ',
            test_values => {
              'appacct.attrs' => '-j 122483 ',
              'usracct.uid' => '91',
              'usracct.gid' => '91',
              'appacct.path' => '/opt/sge/bin/lx24-amd64/',
              'appacct.program' => 'qacct',
            },
          },
        ],
      },
      {
        id => '8a2caaa9-dfcf-47a0-9883-f26d2673cf64',
        ruleclass => 'site.gridengine',
        patterns => [
          '@NUMBER:usracct.uid@:@NUMBER:usracct.gid@ @ESTRING:appacct.path:qselect @@ANYSTRING:appacct.attrs@',
          '@NUMBER:usracct.uid@:@NUMBER:usracct.gid@ @ESTRING:appacct.path:qselect @',
        ],
        values => {
          'appacct.program' => 'qselect',
          'usracct.username' => '$(getent passwd ${usracct.uid})',
        },
        examples => [
          {
            program => 'sge-query-command',
            test_message => '317:102 qselect -qs E ',
            test_values => {
              'appacct.attrs' => '-qs E ',
              'usracct.uid' => '317',
              'usracct.gid' => '102',
              'appacct.path' => '',
              'appacct.program' => 'qselect',
            },
          },
        ],
      }
    ]
  }
