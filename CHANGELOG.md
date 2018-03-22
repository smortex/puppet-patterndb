# 2018-03-22 Release 3.0.0

* new major release
* drop support for puppet < 4.9.0

## 2017-06-07 2.3.0-beta1

* add support for polling hiera

## 2015-08-26 2.2.2

* fix bug in htmlentities that fracked up pdbs iunder ruby 2.1

## 2015-08-26 2.2.1

* context_timeout now accepts Fixnum as well as String
* add parameter order for ruleset
* Drop support for puppet 2.x
* minor author fixes

## 2015-08-26 2.2.0 UNRELEASED

## 2015-08-26 2.1.1 UNRELEASED

* escape special chars in generated xml
* Allow empty patterns in rulesets
* context_timeout and version now accept Fixnum as well as String

## 2014-08-12 2.1.0 Separate Rulesets, Rules and Actions

* rules accept the `order` parameter which controls the order
  of appearance in the merged parser file
* rulesets, rules and actions can now be declared separately
  this pulls in the puppetlabs-concat dependancy
* allow rules and patterns to be strings
  that will be coerced to single-element arrays
  this will make it easier to use this module with puppetdb
  https://tickets.puppetlabs.com/browse/PDB-170
* treat action/message/inherit_properties as a real boolean

## 2014-06-16 2.0.0 Support multiple merged patterndb files

* added support for multiple pattern databases
* class `patterndb::update` replaced by define `patterndb::parser`
* moved parameters from `update` to base class

## 2014-06-10 1.0.0 Initial release
