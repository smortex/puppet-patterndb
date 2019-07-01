#
# htmlentities.rb
#
# This escapes HTML characters. Currently supported: <>
Puppet::Functions.create_function(:'patterndb::htmlentities') do
  def _htmlentities(str)
    case str
    when String
      r_h = {
        '>' => '&gt;',
        '<' => '&lt;',
        '&' => '&amp;',
      }
      r_h.sort.each do |k, v|
        str = str.gsub(%r{#{k}}, v)
      end
    end
    str
  end

  def htmlentities(*arguments)
    if arguments.empty?
      return []
    end

    if arguments.length == 1
      if arguments[0].is_a?(Array)
        foo = arguments[0].map { |e| _htmlentities(e) }
        return foo
      elsif arguments[0].is_a?(Hash)
        raise(Puppet::Error, 'string2array(): `' + arguments[0].to_s + '` is neither a string nor an array')
      end
    end

    _htmlentities(arguments[0])
  end
end

# vim: set ts=2 sw=2 et :
