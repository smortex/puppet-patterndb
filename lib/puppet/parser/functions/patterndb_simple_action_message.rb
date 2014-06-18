module Puppet::Parser::Functions
  newfunction(:patterndb_simple_action_message) do |args|
    message = args[0]
    action_id = args[1]
    message_id = action_id
    Puppet::Parser::Functions.function(:create_resources)
    function_create_resources(['patterndb::simple::action::message', { message_id => message} ])
  end
end

