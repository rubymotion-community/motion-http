# NOTE: Copied from https://github.com/HipByte/Flow/blob/master/flow/json/android/json.rb
class JSON
  def self.load(str)
    tok = Org::JSON::JSONTokener.new(str)
    obj = tok.nextValue
    if obj == nil
      raise "Can't deserialize object from JSON"
    end

    # Transform pure-Java JSON objects to Ruby types.
    convert_java(obj)
  end

  def self.convert_java(obj)
    case obj
      when Org::JSON::JSONArray
        obj.length.times.map { |i| convert_java(obj.get(i)) }
      when Org::JSON::JSONObject
        iter = obj.keys
        hash = Hash.new
        loop do
          break unless iter.hasNext
          key = iter.next
          value = obj.get(key)
          hash[convert_java(key)] = convert_java(value)
        end
        hash
      when Java::Lang::String
        obj.to_s
      when Org::JSON::JSONObject::NULL
        nil
      else
        obj
    end
  end
end
