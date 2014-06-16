* 2014-06-16 1.1.0 Support multiple merged patterndb files
  - added support for multiple pattern databases
    all rulesets can now have a new optional parameter `pdb_name`
    which defaults to `default`
  - `patterndb::update` is now a define instead of a class
  - moved parameters from `update` to base class
* 2014-06-10 1.0.0 Initial release
