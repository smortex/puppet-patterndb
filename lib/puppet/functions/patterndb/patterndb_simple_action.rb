Puppet::Functions.create_function(:'patterndb::patterndb_simple_action') do
  def patterndb_simple_action(*args)
    id = 0
    actions = args[0]
    rule_id = args[1]
    order = args[2]
    return if actions.empty?
    actions.each do |action|
      action_id = "#{rule_id}-#{id}"
      action['_embedded'] = true
      action['rule'] = rule_id
      action['rule_order'] = order
      Puppet::Parser::Functions.function(:create_resources)
      call_function('create_resources', 'patterndb::simple::action', action_id => action)
      id += 1
    end
  end
end
