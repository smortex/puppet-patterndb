module Puppet::Parser::Functions
  newfunction(:patterndb_simple_rule) do |args|
    rules = args
    rules.each do |rule|
      rule.each do |r|
        #function_ensure_resource(['patterndb::simple::rule', r['id'], r ])
        Puppet::Parser::Functions.function(:create_resources)
        function_create_resources(['patterndb::simple::rule', { r['id'] => r} ])
      end
    end
  end
end

