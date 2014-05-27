module Puppet::Parser::Functions
  newfunction(:patterndb_simple_example) do |args|
    id = 0
    examples = args[0]
    rule_id = args[1]
    return if examples.size < 1
    examples.each do |example|
      example_id = "#{rule_id}-#{id}"
      Puppet::Parser::Functions.function(:create_resources)
      function_create_resources(['patterndb::simple::example', { example_id => example} ])
      id = id + 1
    end
  end
end

