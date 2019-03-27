# Copied from https://github.com/HipByte/Flow/blob/44283b31a63bc826d2c068557b6357dc1195680b/flow/base64/cocoa/base64.rb
class Base64
  def self.encode(string)
    data = string.dataUsingEncoding(NSUTF8StringEncoding)
    data.base64EncodedStringWithOptions(0)
  end

  def self.decode(string)
    data = NSData.alloc.initWithBase64EncodedString(string, options: 0)
    NSString.alloc.initWithData(data, encoding: NSUTF8StringEncoding)
  end
end
