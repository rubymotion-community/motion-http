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

# Copied from https://github.com/HipByte/Flow/blob/44283b31a63bc826d2c068557b6357dc1195680b/flow/json/cocoa/json.rb
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
