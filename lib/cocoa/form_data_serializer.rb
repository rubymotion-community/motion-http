class FormDataSerializer
  def self.serialize(params)
    flattened_params = {}
    params.each do |k, v|
      add_param(flattened_params, k, v)
    end
    serialized_params = []
    flattened_params.each do |k, v|
      serialized_params << "#{k}=#{serialize_value(v)}"
    end
    serialized_params.join('&')
  end

  def self.add_param(hash, k, v)
    if v.is_a? Hash
      v.each do |sub_k, sub_v|
        add_param(hash, "#{k}[#{sub_k}]", sub_v)
      end
    else
      hash[k] = v
    end
  end

  def self.serialize_value(v)
    allowed_characters = NSCharacterSet.URLQueryAllowedCharacterSet.mutableCopy
    allowed_characters.removeCharactersInString(":#[]@!$&'()*+,;=")
    NSString.alloc.initWithString(v.to_s).stringByAddingPercentEncodingWithAllowedCharacters(allowed_characters)
  end
end
