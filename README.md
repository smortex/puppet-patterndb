# ccin2p3-patterndb

[![Build Status](https://travis-ci.org/ccin2p3/puppet-patterndb.svg?branch=master)](https://travis-ci.org/ccin2p3/puppet-patterndb)

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What patterndb affects](#what-patterndb-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage](#usage)
5. [Reference](#reference)
6. [Limitations](#limitations)
7. [Development](#development)

##Overview

This module handles patterndb configuration files.

##Module Description

This module will manage the pattern dabase of `syslog-ng`.
It manages existing `pdb` files, or generates new ones using key-value pairs in puppet manifests. No need to edit `XML` files anymore \o/.
Of course, you may also use a combination of both.
Either way, knowledge of `patterndb` is required as the manifests closely match the `XML` structure of patterndb files.
The [syslog-ng documentation](http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.5-guides/en/syslog-ng-ose-v3.5-guide-admin/html-single/index.html#chapter-patterndb) is an excellent source for help on the subject.

##Setup

###What patterndb affects

Depending on the top-level configuration variable `$base_dir`, this module will manage and execute the following elements in order:

0. Manage package `syslog-ng` if not already handled elsewhere (`stdlib/ensure_resource`)
1. Manage `$base_dir/etc/syslog-ng/patterndb.d`
2. Manage the contents of the above directory using [existing](#defined-type-patterndbrawruleset) or [generated](#defined-type-patterndbsimpleruleset) patterndb ruleset files
3. Merge the contents of the latter using `pdbtool` into a temporary file `$temp_dir/syslog-ng/patterndb.xml`
4. (OPTIONAL) Test the resulting patterndb
5. Deploy the temporary file into `$base_dir/var/lib/syslog-ng/patterndb.xml`

Reloading of the syslog-ng daemon is not being taken care of, as the daemon already does that (very well).

###Setup Requirements

This module requires `stdlib` and supports `RedHat` and `Debian` osfamilies.

##Usage

Using defaults

    class { "patterndb": }

Overriding paths

    class { "patterndb":
      $base_dir => "/path/to/syslog-ng/prefix",
      $temp_dir => "/path/to/temp"
    }

##Reference

### Class: patterndb

Manages `Package['syslog-ng']` if `$manage_package` is set to `true`.
Manages `File["$temp_dir"]` as a directory.
Manages `File` resource `"$base_dir/etc/syslog-ng/patterndb.d"` recursively, and purges unknown files.
Manages `File["${base_dir}/var/lib/syslog-ng/patterndb.xml"]` or alternate path if overridden using `$pdb_path`.

#### Optional Parameters

* `$base_dir` Top level directory for resources
* `$temp_dir` Temporary directory for various components
* `$package_name` Name of the `syslog-ng` package. Defaults to the OS standard
* `$manage_package` Boolean to disable the management of the package. Defaults to `true`

###Class: patterndb::update

Handles merging and deploying of [provided](#defined-type-patterndbrawruleset) and/or [generated](#defined-type-patterndbsimpleruleset) `pdb` files.

####Optional Parameters

* syslogng_modules An array of modules to load when running `Exec['pdbtool ...']`

Controls the validation process of the merged patterndb file, *e.g.* `syslogng_modules => [ "tfgeoip" ]` will yield the `Exec` resource `pdbtool test [...] --module tfgeoip`.
This is necessary in case you are using non autoloading modules in patterndb, otherwise your validation will fail and your patterndb will fail to deploy itself.

* test_before_deploy Boolean

Controls wether merged pdb file is validated before being deployed. By default this is set to `true`.
Here's what happens under the hood (code is pretty self-explanatory):

		if $test_before_deploy {
			File['merged_and_deployed_pdb'] ~> Exec['patterndb::merge'] ~> Exec['patterndb::test'] ~> Exec['patterndb::deploy']
		} else {
			File['merged_and_deployed_pdb'] ~> Exec['patterndb::merge'] ~>                                Exec['patterndb::deploy']
		}

There is intentionally no way to test `pdb` files individually, as this only makes sense after the merge.

#### Example

		class { patterndb::update:
			syslogng_modules => [ "tfgeoip", "tfgetent" ],
			test_before_deploy => true
		}

### Defined Type: patterndb::raw::ruleset

Describes existing `pdb` resultsets. Handles the resource deployment of type `File`.

####Parameters

All parameters are passed along to the `File` resource, which will manage the `pdb` file, some of which will only affect operation if working on a directory.

####Mandatory Parameters

* `$source` No default value

####Optional Parameters

* `$ensure` Defaults to `'present'`. Use `'directory'` if we are to handle a bunch of pdb files.
* `$recurse` Defaults to `true`
* `$purge` Defaults to `true`
* `$sourceselect` Defaults to `'all'`
* `$ignore` Defaults to `[ '.svn', '.git' ]`

###Examples

####Single file
    
		patterndb::raw::ruleset { 'raw':
			source => 'puppet:///path/to/my/export/for/myraw.pdb'
		}

####Directory

		patterndb::raw::ruleset { 'raws':
			source => 'puppet:///path/to/my/exports/for/pdb',
			ensure => 'directory',
			purge  => true,
		}

### Defined Type: patterndb::simple::ruleset

Describes a full ruleset, *e.g.* a set of rules matching the same `PROGRAM` macro in syslog-ng. Handles the generation of `pdb` files from scratch.

####Mandatory Parameters

* `$id` A unique identifier for the ruleset. The use of [uuid](http://en.wikipedia.org/wiki/Universally_unique_identifier) is strongly recommended
* `$patterns` An array of strings representing the pattern matching the name of the `PROGRAM` macro in syslog messages, *e.g.* `['sshd', 'login', 'lftpd']`
* `$pubdate` The date the ruleset has been written in the format `YYYY-mm-dd`
* `$rules` An array of hashes describing the [rules](#defined-type-patterndbsimplerule)

####Optional Parameters

* `$version` patterndb ruleset version. Defaults to `4`
* (CURRENTLY IGNORED) `$description` a short description for the ruleset. Defaults to `"generated by puppet"`
* (CURRENTLY IGNORED) `$url` an url pointing to some information on the ruleset. Defaults to `undef`

###Examples

####Minimal

    patterndb::simple::ruleset { 'myruleset':
			id => '9586b525-826e-4c2d-b74f-381039cf470c',
			patterns => [ 'sshd' ],
			pubdate => '2014-03-24',
			rules => [
				{
					id => 'd69bd1ed-17ff-4667-8ea4-087170cbceeb',
					patterns => ['Successful login for user @QSTRING:user:"@ using method @QSTRING:method:"@']
				}
			]
    }

####Full

		patterndb::simple::ruleset { 'pam_unix':
			id => 'd254ec8b-be96-49cb-9424-16fcb1164157',
			patterns => [ 'sshd', 'crond', 'imap', 'login', 'pam', 'su', 'sudo' ],
			pubdate => '1985-10-26',
			version => '4',
			description => 'This ruleset contains patterns for pam_unix log messages',
			url => 'http://www.openpam.org/',
			rules => [
				{
					id => 'b85dfb49-b5e5-4bca-b2ca-5dd28ab13d5e',
					patterns => [
						'pam_unix(@ESTRING:usracct.application::@@ESTRING:usracct.service:)@: session closed for user @ANYSTRING:usracct.username:@'
						'pam_unix(@ESTRING:usracct.application::@@ESTRING:usracct.service:)@: session closed'
					],
					tags => [ 'usracct', 'secevt' ],
					values => {
						'usracct.type' => 'logout',
					},
					examples => [
						{
							program => 'sshd',
							test_message => 'pam_unix(sshd:session): session closed for user mmcfly',
							test_values => {
								'usracct.application' => 'sshd',
								'usracct.service' => 'session',
								'usracct.username' => 'mmcfly',
							}
						}
					],
				},
			],
		}

### Defined Type: patterndb::simple::rule

Describes a rule in a [ruleset](#defined-type-patterndbsimpleruleset).
Currently used for validation only.

####Mandatory Parameters

* `$id` A unique identifier for the rule. The use of [uuid](http://en.wikipedia.org/wiki/Universally_unique_identifier) is strongly recommended
* `$patterns` An array of patterns describing a log message *e.g.* `['Failed @ESTRING:usracct.authmethod: @for invalid user @ESTRING:usracct.username: @from @ESTRING:usracct.device: @port @ESTRING:: @@ANYSTRING:usracct.service@']`
* `$examples` An array of hashes containing [sample log messages](#defined-type-patterndbsimpleexample) which should match `$patterns`

####Optional Parameters

* `$provider` The provider of the rule. This is used to distinguish between who supplied the rule. Defaults to `'puppet'`
* `$ruleclass` The class of the rule — syslog-ng assigns this class to the messages matching a pattern of this rule. Defaults to `'system'`
* `$values` A hash of key-value pairs that are assigned to messages matching the rule. Defaults to `{}`
* `$tags` A list of keywords or tags applied to messages matching the rule. Defaults to `[]`
* `$context_scope` Specifies which messages belong to the same context. See the paragraph [13.5.3](http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.5-guides/en/syslog-ng-ose-v3.5-guide-admin/html/reference-patterndb-schemes.html) of the syslog-ng onlmine manual for this and the 2 other context options. Valid values are: `process`, `program`, `host`, and `global`
* `$context_id` An identifier to group related log messages when using the pattern database to correlate events
* `$context_timeout` The number of seconds the context is stored
* `$actions` An array of [actions](#defined-type-patterndbsimpleaction) to perform when matching this rule

###Defined Type: patterndb::simple::example

Defined type describing sample messages in a [rule](#defined-type-patterndbsimplerule).
Currently used for validation only.
 
####Mandatory Parameters

* `$program` The `PROGRAM` pattern of the test message, *e.g.* `'sshd'`
* `$test_message` A sample log message that should match the [rule](#defined-type-patterndbsimplerule) *e.g.* `Failed password for invalid user deep_thought from 0.0.0.0 port -1 ssh42`

####Optional Parameters

* `$test_values` A hash of name-value pairs to test the results of the parsers used in the pattern, *e.g.* `{'usracct.username' => 'deep_thought'}`

###Defined Type: patterndb::simple::action

Defined type describing an action in a [rule](#defined-type-patterndbsimplerule).
Currently used for validation only.

See the paragraph [13.5.3](http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.5-guides/en/syslog-ng-ose-v3.5-guide-admin/html/reference-patterndb-schemes.html) of the syslog-ng onlmine manual for more details on the parameters:

####Optional Parameters

* `$trigger` Specifies when the action is executed. The trigger attribute has the following possible values: `match` or `timeout`. 
* `$rate` Specifies maximum how many messages should be generated in the specified time period in the following format: messages/second, *e.g.* `1/60`
* `$condition` The action is performed only if the message matches the filter
* `$message` A hash describing the [message](#defined-type-patterndbsimpleactionmessage) to be sent when the action is executed

###Defined Type: patterndb::simple::action::message

Defined type describing action message in an [action](#defined-type-patterndbsimpleaction).
Currently used for validation only.

####Optional Parameters

* `$values` A hash containing a list of key-values describing the message, *e.g.* `{'MESSAGE' => 'generated by syslog-ng', 'PROGRAM' => 'syslog-ng'}`
* `$tags` A list of tags for the generated message
* `$inherit_properties` A boolean to toggle whether the generated message should inherit a copy of all values and tags from the triggering message. Defaults to `true`

##Limitations

* Needs more rspec tests
* No system tests yet
* nested defined types model has maybe better solutions
 
##Development
 
### Testing

* Smoke tests: run `./smoke/test` from the root directory
* For `puppet-rspec` tests use `rake spec` as usual

### Contributing

Send issues or PRs to http://github.com/ccin2p3/puppet-patterndb

