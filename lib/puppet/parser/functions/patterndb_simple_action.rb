module Puppet::Parser::Functions
  id = 0
  newfunction(:patterndb_simple_action) do |args|
    actions = args[0]
    rule_id = args[1]
    return if actions.size < 1
    actions.each do |action|
      action_id = "#{rule_id}-#{id}"
      Puppet::Parser::Functions.function(:create_resources)
      function_create_resources(['patterndb::simple::action', { action_id => action} ])
      id = id + 1
    end
  end
end

