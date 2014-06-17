# ccin2p3-patterndb

[![Build Status](https://travis-ci.org/ccin2p3/puppet-patterndb.svg?branch=master)](https://travis-ci.org/ccin2p3/puppet-patterndb)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What patterndb affects](#what-patterndb-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage](#usage)
5. [Reference](#reference)
6. [Limitations](#limitations)
7. [Development](#development)

## Overview

This module handles *patterndb* configuration files for *syslog-ng* pattern parsers.

## Module Description

This module will manage the pattern databases of *syslog-ng* by using existing files, or by generating them using key-value pairs in puppet manifests. No need to edit *XML* files anymore \o/. It is possible to painlessly migrate from an existing base of *rulesets* by using a combination of the latter. Knowledge of *patterndb* is required as the manifests closely match the hierarchical structure as described in detail in the [syslog-ng documentation](http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.5-guides/en/syslog-ng-ose-v3.5-guide-admin/html-single/index.html#chapter-patterndb).

## Setup

### What patterndb affects

Depending on the top-level configuration variables `$base_dir` and `$temp_dir`, this module will manage and execute the following elements in order:

0. (OPTIONAL) Manage package `syslog-ng`
1. Manage `$base_dir/etc/syslog-ng/patterndb.d` recursively
2. Manage the contents of the above directory using [existing](#defined-type-patterndbrawruleset) or [generated](#defined-type-patterndbsimpleruleset) patterndb *ruleset* files
3. Merge the contents of the latter using `pdbtool` into a temporary file `${temp_dir}/syslog-ng/patterndb/${pdb_name}.xml` where `$pdb_name` is the name of the *patterndb* (you can have as many as you want, *e.g.* for *staged parsing*.
4. (OPTIONAL) Test the resulting patterndbs
5. Deploy the temporary files into `${base_dir}/var/lib/syslog-ng/patterndb/${pdb_name}.xml`

Reloading of the *syslog-ng* daemon is not being taken care of, as the latter already does that on its own by polling the *patterndb* file for change.

### Setup Requirements

This module requires *stdlib* and supports *RedHat* and *Debian* *osfamilies*.

## Usage

The most straightforward way to create a *patterndb* resource is to load the class, then define *rulesets*:

Using defaults
```puppet
class { "patterndb": }
```
Overriding paths
```puppet
class { "patterndb":
  $base_dir => "/",
  $temp_dir => "/tmp"
}
```
Defining *rulesets*

```puppet
patterndb::ruleset::simple { 'myruleset':
  id => '12345',
  patterns => [ 'a', 'b' ],
  rules => [ { id => '54321', patterns => [ '@ANYSTRING@' ] } ]
}
patterndb::ruleset::raw { 'yourruleset':
  source => 'puppet:///path/to/your/export/xml.pdb'
}
```
This will create a new *patterndb* in `/var/lib/syslog-ng/patterndb/default.xml` with the two *rulesets* `myruleset` and `yourruleset`.

## Reference

### Class: patterndb

This class will manage the following *resources*:

* `Package[$package_name]` if `$manage_package` is set to `true`.
* `File[$temp_dir]` as a directory.
* `File["${base_dir}/etc/syslog-ng/patterndb.d"]` recursively, purging unknown files.
* `File["${base_dir}/var/lib/syslog-ng/patterndb/${pdb_name}.xml"]` for each `$pdb_name` (defaults to `'default'`)

#### Optional Parameters

* `$base_dir` Top level directory for resources
* `$temp_dir` Temporary directory for various components
* `$package_name` Name of the `syslog-ng` package. Defaults to the OS shipped
* `$manage_package` Boolean to control the management of the package. Defaults to `true`
* `$syslogng_modules` An array of `syslog-ng` modules to use. This will be used for other resources *e.g.* [update](#defined-type-patterndbupdate). Defaults to `[]`
* `$test_before_deploy` A boolean which controls wether to test the *patterndbs* before deploying (see [update](#defined-type-patterndbupdate)). Defaults to `true`

### Defined Type: patterndb::update

Handles merging and deploying of [provided](#defined-type-patterndbrawruleset) and/or [generated](#defined-type-patterndbsimpleruleset) `pdb` files.
The `$title` or `$name` of the defined resource will control which merged patterndb file is targeted. If using the defaults, and only one pattern parser, you probably won't need to call this type, as it will get created for you when creating a *ruleset*.

#### Optional Parameters

* `$syslogng_modules` An array of *syslog-ng modules* to load. Controls the validation process of the merged patterndb file, *e.g.* `syslogng_modules => [ "tfgeoip" ]` will yield the `Exec["pdbtool test [...] --module tfgeoip"]`. This is necessary in case you are using non autoloading modules in *patterndb*, otherwise your validation will fail and your *patterndb* will fail to deploy itself. Defaults to the class value.
* `$test_before_deploy Boolean` Controls wether merged *patterndb* file is tested before being deployed. Defaults to the class value. For reference, here's what happens under the hood (code is pretty self-explanatory):

```puppet
if $test_before_deploy {
  File['patterndb::file'] ~> Exec['patterndb::merge'] ~> Exec['patterndb::test'] ~> Exec['patterndb::deploy']
} else {
  File['patterndb::file'] ~> Exec['patterndb::merge'] ~>                            Exec['patterndb::deploy']
}
```
There is intentionally no way to test individual *patterndb* files, as this only makes sense after the merge.

#### Example

```puppet
patterndb::update { 'default':
  syslogng_modules => [ "tfgeoip", "tfgetent" ],
  test_before_deploy => true
}
```

### Defined Type: patterndb::raw::ruleset

Describes existing *patterndb* resultsets. Handles the resource deployment of type `File`.

#### Parameters

All parameters are passed along to the `File` resource, which will manage the *patterndb* file, some of which will only affect operation if working on a directory.

#### Mandatory Parameters

* `$source` The source of the *patterndb*. Will be passed to the `File` resource

#### Optional Parameters

* `$pdb_name` Name of the target merged *patterndb*. Defaults to `'default'` which references the *patterndb* file with path `${base_dir}/var/lib/syslog-ng/patterndb/default.xml`
* `$ensure` Defaults to `'present'`. Use `'directory'` if we are to handle a bunch of pdb files.
* `$recurse` Defaults to `true`
* `$purge` Defaults to `true`
* `$sourceselect` Defaults to `'all'`
* `$ignore` Defaults to `[ '.svn', '.git' ]`

### Examples

#### Single file

```puppet
patterndb::raw::ruleset { 'raw':
  source => 'puppet:///path/to/my/export/for/myraw.pdb'
}
```

#### Directory

```puppet
patterndb::raw::ruleset { 'raws':
  source => 'puppet:///path/to/my/exports/for/pdb',
  ensure => 'directory',
  purge  => true,
}
```

#### Multiple patterndb parsers

```puppet
patterndb::raw::ruleset { 'ruleset_for_pdb_1':
  pdb_name => 'pdb1',
  source => 'puppet:///path/to/my/export/for/myraw_1.pdb'
}
patterndb::raw::ruleset { 'ruleset_for_pdb_2':
  pdb_name => 'pdb2',
  source => 'puppet:///path/to/my/export/for/myraw_2.pdb'
}
```

### Defined Type: patterndb::simple::ruleset

Describes a full *ruleset*, *e.g.* a set of *rules* matching the same *PROGRAM* *macro* in *syslog-ng*. Handles the generation of *patterndb* files from scratch.

#### Mandatory Parameters

* `$id` A unique identifier for the *ruleset*. The use of [uuid](http://en.wikipedia.org/wiki/Universally_unique_identifier) is strongly recommended
* `$patterns` An array of strings representing the pattern matching the name of the *PROGRAM* macro in *syslog* messages, *e.g.* `['sshd', 'login', 'lftpd']`
* `$pubdate` The date the *ruleset* has been written in the format `YYYY-mm-dd`
* `$rules` An array of hashes describing the [rules](#defined-type-patterndbsimplerule)

#### Optional Parameters

* `$pdb_name` Name of the target merged *patterndb*. Defaults to `'default'` which references the *patterndb* file with path `${base_dir}/var/lib/syslog-ng/patterndb/default.xml`
* `$version` *patterndb* *ruleset* version. Defaults to `4`
* `$description` a short description for the *ruleset*. Defaults to `"generated by puppet"`
* `$url` an url pointing to some information on the *ruleset*. Defaults to `undef`

### Examples

#### Minimal

```puppet
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
```

#### Full

```puppet
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
```

### Defined Type: patterndb::simple::rule

Describes a *rule* in a [ruleset](#defined-type-patterndbsimpleruleset). Currently used for validation only.

#### Mandatory Parameters

* `$id` A unique identifier for the *rule*. The use of [uuid](http://en.wikipedia.org/wiki/Universally_unique_identifier) is strongly recommended
* `$patterns` An array of patterns describing a log message *e.g.* `['Failed @ESTRING:usracct.authmethod: @for invalid user @ESTRING:usracct.username: @from @ESTRING:usracct.device: @port @ESTRING:: @@ANYSTRING:usracct.service@']`
* `$examples` An array of hashes containing [sample log messages](#defined-type-patterndbsimpleexample) which should match `$patterns`

#### Optional Parameters

* `$provider` The *provider* of the *rule*. This is used to distinguish between who supplied the *rule*. Defaults to `'puppet'`
* `$ruleclass` The *class* of the *rule* - *syslog-ng* assigns this *class* to the messages matching a *pattern* of this *rule*. Defaults to `'system'`
* `$values` A hash of key-value pairs that are assigned to messages matching the *rule*. Defaults to `{}`
* `$tags` A list of keywords or *tags* applied to messages matching the *rule*. Defaults to `[]`
* `$context_scope` Specifies which messages belong to the same *context*. See the paragraph [13.5.3](http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.5-guides/en/syslog-ng-ose-v3.5-guide-admin/html/reference-patterndb-schemes.html) of the syslog-ng onlmine manual for this and the 2 other context options. Valid values are: `process`, `program`, `host`, and `global`
* `$context_id` An identifier to group related log messages when using the *pattern database* to *correlate* events
* `$context_timeout` The number of seconds the *context* is stored
* `$actions` An array of [actions](#defined-type-patterndbsimpleaction) to perform when matching this rule

### Defined Type: patterndb::simple::example

Defined type describing sample messages in a [rule](#defined-type-patterndbsimplerule).
Currently used for validation only.
 
#### Mandatory Parameters

* `$program` The `PROGRAM` *pattern* of the test message, *e.g.* `'sshd'`
* `$test_message` A sample log message that should match the [rule](#defined-type-patterndbsimplerule) *e.g.* `Failed password for invalid user deep_thought from 0.0.0.0 port -1 ssh42`

#### Optional Parameters

* `$test_values` A hash of name-value pairs to test the results of the *parsers* used in the pattern, *e.g.* `{'usracct.username' => 'deep_thought'}`

### Defined Type: patterndb::simple::action

Defined type describing an *action* in a [rule](#defined-type-patterndbsimplerule).
Currently used for validation only.

See the paragraph [13.5.3](http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.5-guides/en/syslog-ng-ose-v3.5-guide-admin/html/reference-patterndb-schemes.html) of the syslog-ng online manual for more details on the parameters:

#### Optional Parameters

* `$trigger` Specifies when the *action* is executed. The *trigger* attribute has the following possible values: `match` or `timeout`. 
* `$rate` Specifies maximum how many messages should be generated in the specified time period in the following format: messages/second, *e.g.* `1/60`
* `$condition` The *action* is performed only if the message matches the *filter*
* `$message` A hash describing the [message](#defined-type-patterndbsimpleactionmessage) to be sent when the action is executed

### Defined Type: patterndb::simple::action::message

Defined type describing *action* message in an [action](#defined-type-patterndbsimpleaction).
Currently used for validation only.

#### Optional Parameters

* `$values` A hash containing a list of key-values describing the message, *e.g.* `{'MESSAGE' => 'generated by syslog-ng', 'PROGRAM' => 'syslog-ng'}`
* `$tags` A list of *tags* for the generated message
* `$inherit_properties` A boolean to toggle whether the generated message should inherit a copy of all *values* and *tags* from the triggering message. Defaults to `true`

## Limitations

* Needs more rspec tests
* No system tests yet
* nested defined types model has maybe better solutions
 
## Development
 
### Testing

* Smoke tests: run `./smoke/test` from the root directory
* For `puppet-rspec` tests use `bundle install && bundle exec rake spec`

### Contributing

Send issues or PRs to http://github.com/ccin2p3/puppet-patterndb

