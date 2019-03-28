# Copyright (c) 2015-2016, HipByte (info@hipbyte.com) and contributors.
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met: 

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer. 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution. 

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# NOTE: Copied from https://github.com/HipByte/Flow/blob/master/flow/json/android/json.rb
class JSON
  def self.parse(str)
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

class Object
  def to_json
    # The Android JSON API expects real Java String objects.
    @@fix_string ||= (lambda do |obj|
      case obj
        when String, Symbol
          obj = obj.toString
        when Hash
          map = Hash.new
          obj.each do |key, value|
            key = key.toString if key.is_a?(String) || key.is_a?(Symbol)
            value = @@fix_string.call(value)
            map[key] = value
          end
          obj = map
        when Array
          obj = obj.map do |item|
            (item.is_a?(String) || item.is_a?(Symbol)) ? item.toString : @@fix_string.call(item)
          end
      end
      obj
    end)

    obj = Org::JSON::JSONObject.wrap(@@fix_string.call(self))
    if obj == nil
      raise "Can't serialize object to JSON"
    end
    obj.toString.to_s
  end
end
