# ccin2p3-syslogng

This module handles syslog-ng configuration files.
As of 2014-03-17 this module only handles patterndb configuration files.
Hopefully it will be merged to one of the other available syslog-ng puppet modules.

## Features

* Simple::Ruleset makes it possible to generate the XML using a puppet class
* Raw::Ruleset manages old-school pdb files
* Reloads patterndb

## Testing

To test this module simply run `tests/run.sh` from the root directory
