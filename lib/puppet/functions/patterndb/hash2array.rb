#
# hash2array.rb
#
# This converts a hash to an array containing that hash. Empty argument
# lists are converted to an empty array. Arrays are left untouched. Hashes are
# converted to arrays of alternating keys and values. Strings throw an error.
Puppet::Functions.create_function(:'patterndb::hash2array') do
  def hash2array(*arguments)
    if arguments.empty?
      return []
    end

    if arguments.length == 1
      return arguments[0] if arguments[0].is_a?(Array)
      return [arguments[0]] if arguments[0].is_a?(Hash)
      raise(Puppet::Error, 'hash2array(): `' + arguments[0].to_s + '` is neither a hash nor an array')
    end

    return arguments
  end
end

# vim: set ts=2 sw=2 et :
