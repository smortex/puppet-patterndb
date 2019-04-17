#
# hash2array.rb
#

module Puppet::Parser::Functions
  newfunction(:hash2array, type: :rvalue, doc: <<-EOS
This converts a hash to an array containing that hash. Empty argument
lists are converted to an empty array. Arrays are left untouched. Hashes are
converted to arrays of alternating keys and values. Strings throw an error.
    EOS
             ) do |arguments|

    if arguments.empty?
      return []
    end

    if arguments.length == 1
      if arguments[0].is_a?(Array)
        return arguments[0]
      elsif arguments[0].is_a?(Hash)
        result = [arguments[0]]
        return result
      else
        raise(Puppet::Error, 'hash2array(): `' + arguments[0].to_s + '` is neither a hash nor an array')
      end
    end

    return arguments
  end
end

# vim: set ts=2 sw=2 et :
