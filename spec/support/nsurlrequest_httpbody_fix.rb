class NSMutableURLRequest
  alias_method :original_setHTTPBody, :setHTTPBody
  def setHTTPBody(value)
    NSURLProtocol.setProperty(value, forKey: 'HTTPBody', inRequest: self) if value
    original_setHTTPBody(value)
  end
end

class NSURLRequest
  def HTTPBody
    NSURLProtocol.propertyForKey('HTTPBody', inRequest: self)
  end
end
