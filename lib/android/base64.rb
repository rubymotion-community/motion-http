# Copied from https://github.com/HipByte/Flow/blob/44283b31a63bc826d2c068557b6357dc1195680b/flow/base64/android/base64.rb
class Base64
  def self.encode(string)
    bytes = Java::Lang::String.new(string).getBytes("UTF-8")
    Android::Util::Base64.encodeToString(bytes, Android::Util::Base64::NO_WRAP)
  end

  def self.decode(string)
    java_string = Java::Lang::String.new(string)
    bytes = Android::Util::Base64.decode(java_string, Android::Util::Base64::NO_WRAP)
    Java::Lang::String.new(bytes, "UTF-8")
  end
end
