#
# htmlentities.rb
#

def _htmlentities(str)
  case str
    when String
      r_h = {
        '>' => '&gt;',
        '<' => '&lt;',
        '&' => '&amp;',
      }
      r_h.each do |k,v|
        str = str.gsub(/#{k}/,v)
      end
      return str
    else
      return str
    end
end

module Puppet::Parser::Functions
  newfunction(:htmlentities, :type => :rvalue, :doc => <<-EOS
This escapes HTML characters. Currently supported: <>
    EOS
  ) do |arguments|

    if arguments.empty?
        return []
    end
    
    if arguments.length == 1
        if arguments[0].kind_of?(Array)
           foo = arguments[0].map { |e| _htmlentities(e) }
           return foo
        elsif arguments[0].kind_of?(Hash)
            raise(Puppet::Error, "string2array(): `" + arguments[0].to_s + "` is neither a string nor an array")
        end
    end

    _htmlentities(arguments[0])
  end
end

# vim: set ts=2 sw=2 et :
