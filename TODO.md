* reduce number of fragments by looping in templates instead
* fix bug when action is defined for a rule with order: concat fragments get mixed up
* empty actions sections do not validate #3 
* handle examples using concat so we can use string2array
* escape htmlentities in patterns and test messages
  - just added horrible handling of <>
* purge deployed files if needed: currently when removing all rulesets from a parser, the merged file stays in place in /var/lib/syslog-ng/patterndb/<parser>.xml
* rules should be able to reference rulesets by name and by id
* ruleset names must not contain '/' char as the module uses that to create files
