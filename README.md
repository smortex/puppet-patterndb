# ccin2p3-syslogng

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What syslogng affects](#what-[modulename]-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

##Overview

This module handles syslog-ng configuration files.
As of 2014-03-17 this module only handles patterndb configuration files.
Hopefully it will be merged to one of the other available syslog-ng puppet modules.

##Module Description

This module will manage the pattern dabase of `syslog-ng`.
It makes it possible to either manage existing `pdb` files, or generate new ones using key-value pairs in puppet manifests.
Of course, you may also use a combination of both.
Either way, knowledge of `patterndb` is required as the manifests closely match the `XML` structure of patterndb files.
The [syslog-ng documentation](http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.5-guides/en/syslog-ng-ose-v3.5-guide-admin/html-single/index.html#chapter-patterndb) is an excellent source for help on the subject.

##Setup

###What syslogng affects

Depending on the top-level configuration variable `$base_dir`, this module will manage and execute the following elements in the same order:

* Manage `$base_dir/etc/syslog-ng/patterndb.d`
* Merge the contents of the latter using `pdbtool`
* Test the resulting patterndb
* Manage `$base_dir/var/lib/syslog-ng/patterndb.xml`

Some temporary files will be created on `$tmp_dir/syslog-ng/`

###Setup Requirements

This module requires `stdlib`

##Usage

###Synopsis

    class { "syslogng": }

    class { "syslogng":
      $base_dir => "/path/to/syslog-ng/prefix"
    }

###Generating patterndb rulesets from scratch

    syslogng::pdb::simple::ruleset { 'myruleset':
			id => '9586b525-826e-4c2d-b74f-381039cf470c',
			patterns => [ 'sshd', 'login', 'ftpd' ],
			pubdate => '2014-03-24',
			rules => [
				{
					id => 'd69bd1ed-17ff-4667-8ea4-087170cbceeb',
					ruleclass => 'login',
					patterns => ['Successful login for user @QSTRING:user:"@ using method @QSTRING:method:"@']
				}
			]
    }

###Generating patterndb rulesets using existing files in pdb format

In case of a single file
    
		syslogng::pdb::raw::ruleset { 'raw':
			source => 'puppet:///path/to/my/export/for/myraw.pdb'
		}

Or a directory

		syslogng::pdb::raw::ruleset { 'raws':
			source => 'puppet:///path/to/my/exports/for/pdb',
			ensure => 'directory'
		}

###Examples

For a more advanced usage or examples please look into the tests directory.

##Reference

###syslogng::pdb::raw::ruleset

Manage existing `pdb` files

###syslogng::pdb::simple::ruleset

Generate and manage `pdb` files

###syslogng::pdb::update

Merge and deploy `pdb` files

####Parameters

* syslogng_modules => [ "module1", "module2", ... ]

Controls the validation process of the merged patterndb file, e.g. `syslogng_modules => [ "tfgeoip" ]` will yield the `Exec` resource `pdbtool test [...] --module tfgeoip`.
This is necessary in case you are using non autoloading modules in patterndb, otherwise your validation will fail and your patterndb will fail to deploy itself.

#### Example

		class { syslogng::pdb::update:
			syslogng_modules => [ "tfgeoip", "getent" ]
		}

##Limitations

Only handles pdb at the time.
Will probably be merged to other syslog-ng modules
 
##Development
 
### Testing

To test this module simply run `tests/run.sh` from the root directory

### Contributing

Send issues or PRs to http://github.com/ccin2p3/puppet-syslogng

