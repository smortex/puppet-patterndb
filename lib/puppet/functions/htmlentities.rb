#
# htmlentities.rb
#
# This escapes HTML characters. Currently supported: <>
Puppet::Functions.create_function(:htmlentities) do
  dispatch :format_number do
    param 'Numeric', :input_number
    return_type 'String'
  end
  dispatch :format_string do
    param 'String', :input_string
    return_type 'String'
  end
  dispatch :format_array do
    param 'Array[String[1]]', :input_array
    return_type 'Array[String[1]]'
  end
  def _htmlentities(str)
    r_h = {
      '>' => '&gt;',
      '<' => '&lt;',
      '&' => '&amp;',
    }
    r_h.sort.each do |k, v|
      str = str.gsub(%r{#{k}}, v)
    end
    str
  end

  def format_number(input_number)
    _htmlentities(input_number.to_s)
  end

  def format_string(input_string)
    _htmlentities(input_string)
  end

  def format_array(input_array)
    input_array.map { |e| _htmlentities(e) }
  end
end

# vim: set ts=2 sw=2 et :
