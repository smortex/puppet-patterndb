module Puppet::Parser::Functions
  newfunction(:patterndb_simple_rule) do |args|
    rules = args
    ruleset = rules.shift
    rules.each do |rule|
      rule.each do |r|
        r['ruleset'] = ruleset
        r['_embedded'] = true
        Puppet::Parser::Functions.function(:create_resources)
        function_create_resources(['patterndb::simple::rule', { r['id'] => r} ])
      end
    end
  end
end

