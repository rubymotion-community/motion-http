class ParamsEncoder
  def self.encode(arg)
    Java::Net::URLEncoder.encode(arg, 'UTF-8')
  end
end
