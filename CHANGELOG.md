* 2014-07-15 2.1.0 Coerce some types
  - allow rules and patterns to be strings
    that will be coerced to single-element arrays
    this will make it easier to use this module with puppetdb
    https://tickets.puppetlabs.com/browse/PDB-170
  - treat action/message/inherit_properties as a real boolean
* 2014-06-16 2.0.0 Support multiple merged patterndb files
  - added support for multiple pattern databases
  - class `patterndb::update` replaced by define `patterndb::parser`
  - moved parameters from `update` to base class
* 2014-06-10 1.0.0 Initial release
