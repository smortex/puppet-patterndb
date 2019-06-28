Puppet::Functions.create_function(:'patterndb::patterndb_simple_action_message') do
  def patterndb_simple_action_message(*args)
    message = args[0]
    action_id = args[1]
    message_id = action_id
    Puppet::Parser::Functions.function(:create_resources)
    call_function('create_resources', 'patterndb::simple::action::message', { message_id => message})
  end
end

