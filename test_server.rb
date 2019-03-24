require 'sinatra'

disable :logging

before do
  puts "#{request.request_method} #{request.path_info} #{request.env['HTTP_VERSION']}"
  headers = Hash[*request.env.select {|k,v| k.start_with? 'HTTP_'}
  .collect {|k,v| [k.sub(/^HTTP_/, ''), v]}
  .collect {|k,v| [k.split('_').collect(&:capitalize).join('-'), v]}
  .sort
  .flatten]
  headers.each do |k,v|
    next if k == 'Host'
    next if k == 'Version'
    puts "#{k}: #{v}"
  end
  if request.content_length && request.content_length.to_i > 0
    puts "Content-Type: #{request.media_type}"
    puts "Content-Length: #{request.content_length}"
    puts request.body.read
  end
  puts
end

get '*' do
  headers 'content-type' => 'application/json'
  body '[{"title":"Example Post"}]'
end

post '*' do
  headers 'content-type' => 'application/json'
  body '[{"title":"Example Post"}]'
end
