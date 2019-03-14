class JSON
  def self.parse(json_string)
    error_ptr = Pointer.new(:id)
    object = NSJSONSerialization.JSONObjectWithData(json_string.dataUsingEncoding(NSUTF8StringEncoding), options: 0, error: error_ptr)
    unless object
      raise error_ptr[0].description
    end
    object
  end

  def self.generate(object)
    raise "Invalid JSON object" unless NSJSONSerialization.isValidJSONObject(object)
    error_ptr = Pointer.new(:id)
    data = NSJSONSerialization.dataWithJSONObject(object, options: 0, error: error_ptr)
    unless data
      raise error_ptr[0].description
    end
    data.to_s
  end
end

class Object
  def to_json
    JSON.generate(self)
  end
end
