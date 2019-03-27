class ParamsEncoder
  # TODO: check if iOS implements anything more performant/reliable that we should be using.
  def self.encode(arg)
    arg.to_s.gsub(/([^ a-zA-Z0-9_.-]+)/) do |m|
      '%' + m.unpack('H2' * m.bytesize).join('%').upcase
    end.tr(' ', '+')
  end
end
