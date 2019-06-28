#
class { 'patterndb':
  manage_package     => false,
  base_dir           => '/tmp',
  syslogng_modules   => [],
  test_before_deploy => true,
}

patterndb::simple::ruleset { 'yum':
  id       => 'f2ff6bd5-749e-4c56-bbae-fcc3edc19897',
  patterns => [ 'yum', 'yum-initupdate' ],
  pubdate  => '2014-04-03',
  rules    => [
    {
      id       => '0c579629-0359-4e17-af30-19cfc3bf2ef8',
      patterns => [
# for package versions numbers and other characterse.g. my-best-app-4-2.noarch
        'Installed: @PCRE:tmp.package_name:(?:\w+-)+@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
        'Installed: @ESTRING:appacct.epoch::@@PCRE:tmp.package_name:(?:\w+-)+@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
# for package versions with only numbers e.g. my-best-app-4-2.noarch
        'Installed: @PCRE:tmp.package_name:(?:\w+-)+(?!\d+\.)@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
        'Installed: @ESTRING:appacct.epoch::@@PCRE:tmp.package_name:(?:\w+-)+(?!\d+\.)@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
#
      ],
      tags     => [ 'appacct' ],
      values   => {
# the following removes the trailing dash
        'appacct.rsname' => '$(substr "${tmp.package_name}" "0" "-1")',
#
        'appacct.rstype' => 'install',
      },
      examples => [
        {
          program      => 'yum',
          test_message => 'Installed: 4:perl-Time-HiRes-1.9721-136.el6.x86_64',
          test_values  => {
            'appacct.rsname'  => 'perl-Time-HiRes',
            'appacct.epoch'   => '4',
            'appacct.version' => '1.9721',
            'appacct.release' => '136.el6',
            'appacct.arch'    => 'x86_64',
            'appacct.rstype'  => 'install',
          },
        },
        {
          program      => 'yum',
          test_message => 'Installed: token-forge-2-1.x86_64',
          test_values  => {
            'appacct.rsname'  => 'token-forge',
            'appacct.version' => '2',
            'appacct.release' => '1',
            'appacct.arch'    => 'x86_64',
            'appacct.rstype'  => 'install',
          },
        },
        {
          program      => 'yum',
          test_message => 'Installed: perl-Class-MakeMethods-1.01-5.el6.noarch',
          test_values  => {
            'appacct.rsname'  => 'perl-Class-MakeMethods',
            'appacct.version' => '1.01',
            'appacct.release' => '5.el6',
            'appacct.arch'    => 'noarch',
            'appacct.rstype'  => 'install',
          },
        },
      ],
    },
    {
      id       => '347533ea-c8ab-41b3-a343-6d9204cc7680',
      patterns => [
# for package versions numbers and other characterse.g. my-best-app-4-2.noarch
        'Updated: @PCRE:tmp.package_name:(?:\w+-)+@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
        'Updated: @ESTRING:appacct.epoch::@@PCRE:tmp.package_name:(?:\w+-)+@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
# for package versions with only numbers e.g. my-best-app-4-2.noarch
        'Updated: @PCRE:tmp.package_name:(?:\w+-)+(?!\d+\.)@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
        'Updated: @ESTRING:appacct.epoch::@@PCRE:tmp.package_name:(?:\w+-)+(?!\d+\.)@@ESTRING:appacct.version:-@@PCRE:appacct.release:.*(?=\.)@.@ESTRING:appacct.arch:@',
#
      ],
      tags     => [ 'appacct' ],
      values   => {
        'appacct.rsname' => '$(substr "${tmp.package_name}" "0" "-1")',
        'appacct.rstype' => 'update',
      },
      examples => [
        {
          program      => 'yum',
          test_message => 'Updated: python-boto-2.25.0-2.el6.noarch',
          test_values  => {
            'appacct.rsname'  => 'python-boto',
            'appacct.version' => '2.25.0',
            'appacct.release' => '2.el6',
            'appacct.arch'    => 'noarch',
            'appacct.rstype'  => 'update',
          },
        },
      ],
    },
    {
      id       => '73b7803c-9e1f-4f1a-afa6-8eb7a6725f3a',
      patterns => [
        'Erased: @ANYSTRING:appacct.rsname@',
      ],
      tags     => [ 'appacct' ],
      values   => {
        'appacct.rstype' => 'erase',
      },
      examples => [
        {
          program      => 'yum',
          test_message => 'Erased: nagios-plugins-ups',
          test_values  => {
            'appacct.rsname' => 'nagios-plugins-ups',
            'appacct.rstype' => 'erase',
          },
        },
      ]
    }
  ],
}
