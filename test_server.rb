require 'sinatra'

if ENV['bind']
  set :bind, ENV['bind']
end
disable :logging

helpers do
  def restricted_area
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def http_protect!
    return if http_authorized?
    restricted_area
  end

  def token_protect!
    return if token_authorized?
    restricted_area
  end

  def token_authorized?
    request.env.fetch('HTTP_AUTHORIZATION', nil) &&
    'rubymotion' == request.env['HTTP_AUTHORIZATION'].match(/Token token="(.*)"/).captures.first
  end

  def http_authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'letmein']
  end
end

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

get '/basic_auth' do
  http_protect!
  "Welcome"
end

get('/token_auth') do
  token_protect!
  "Welcome"
end

get '*' do
  headers 'content-type' => 'application/json'
  body '[{"title":"Example Post"}]'
end

post '*' do
  headers 'content-type' => 'application/json'
  body '[{"title":"Example Post"}]'
end
