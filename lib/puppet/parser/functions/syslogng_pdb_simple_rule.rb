module Puppet::Parser::Functions
  newfunction(:syslogng_pdb_simple_rule) do |args|
    rules = args
    rules.each do |rule|
      rule.each do |r|
        #function_ensure_resource(['syslogng::pdb::simple::rule', r['id'], r ])
        Puppet::Parser::Functions.function(:create_resources)
        function_create_resources(['syslogng::pdb::simple::rule', { r['id'] => r} ])
      end
    end
  end
end

