module Puppet::Parser::Functions
  newfunction(:patterndb_simple_action) do |args|
    id = 0
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

