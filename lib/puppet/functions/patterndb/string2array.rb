#
# string2array.rb
#
# This converts a string to an array containing that single element. Empty argument
# lists are converted to an empty array. Arrays are left untouched. Hashes throw
# an error
Puppet::Functions.create_function(:'patterndb::string2array') do
  def string2array(*arguments)
    if arguments.empty?
      return []
    end

    if arguments.length == 1
      return arguments[0] if arguments[0].is_a?(Array)
      raise(Puppet::Error, 'string2array(): `' + arguments[0].to_s + '` is neither a string nor an array') if arguments[0].is_a?(Hash)
    end

    arguments
  end
end

# vim: set ts=2 sw=2 et :
