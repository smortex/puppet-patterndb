Puppet::Functions.create_function(:'patterndb::patterndb_simple_example') do
  def patterndb_simple_example(*args)
    id = 0
    examples = args[0]
    rule_id = args[1]
    return if examples.size < 1
    examples.each do |example|
      example_id = "#{rule_id}-#{id}"
      Puppet::Parser::Functions.function(:create_resources)
      call_function('create_resources', 'patterndb::simple::example', { example_id => example})
      id = id + 1
    end
  end
end

