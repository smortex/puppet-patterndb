Puppet::Functions.create_function(:'patterndb::patterndb_simple_rule') do
  def patterndb_simple_rule(*args)
    rules = args
    ruleset = rules.shift
    rules.each do |rule|
      rule.each do |r|
        if (! r.has_key?('id')) then
          fail("Failed to create embedded rule for ruleset `#{ruleset}`: no 'id' provided!")
        end
        r['ruleset'] = ruleset
        r['_embedded'] = true
        Puppet::Parser::Functions.function(:create_resources)
        call_function('create_resources', 'patterndb::simple::rule', { r['id'] => r})
      end
    end
  end
end

