#
# string2array.rb
#

module Puppet::Parser::Functions
  newfunction(:string2array, type: :rvalue, doc: <<-EOS
This converts a string to an array containing that single element. Empty argument
lists are converted to an empty array. Arrays are left untouched. Hashes throw
an error
    EOS
             ) do |arguments|

    if arguments.empty?
      return []
    end

    if arguments.length == 1
      if arguments[0].is_a?(Array)
        return arguments[0]
      elsif arguments[0].is_a?(Hash)
        raise(Puppet::Error, 'string2array(): `' + arguments[0].to_s + '` is neither a string nor an array')
      end
    end

    return arguments
  end
end

# vim: set ts=2 sw=2 et :
