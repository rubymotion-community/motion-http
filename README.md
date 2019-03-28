# motion-http

A cross-platform HTTP Client for RubyMotion that's quick and easy to use.

Supported platforms:
- iOS, macOS, tvOS, watchOS
- Android

On Android, this gem depends on the super popular [OkHttp](http://square.github.io/okhttp/) networking library.

Please note that this library is still a work in progress. Please report bugs and suggestions for improvement!

## Installation

Add this line to your application's Gemfile:

    gem 'motion-http'

And then execute:

    $ bundle
    $ rake gradle:install # for Android apps

### iOS Specific Configuration

If you will be making insecure HTTP requests (not HTTPS), you will need to explicitly allow insecure HTTP requests by adding this line to your app's configuration in your Rakefile:

    app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }

## Usage

Using `motion-http` is quick and easy. You can use the simple approach for making one-off requests, or the advanced approach of creating a reusable API client for further customization.

### Simple Usage

The basic syntax for a request looks like this:
```ruby
HTTP.method(url, options) do |response|
  # this will be called asynchronously
end
```
Where `method` can be either `get`, `post`, `put`, `patch`, `delete`, `head`, `options`, or `trace`.

For example, to make a simple `GET` request:
```ruby
HTTP.get("http://www.example.com") do |response|
  if response.success?
    puts "Success!"
  else
    puts "Oops! Something went wrong."
  end
end
```

If you need to specify query params:
```ruby
HTTP.get("http://www.example.com/search", params: { term: "my search term" }) do |response|
  # ...
end
```

The response object contains the status code, headers, body, and shortcut methods for checking the response status:
```ruby
HTTP.get("http://example.com") do |response|
  puts response.status_code.to_s
  puts response.headers.inspect
  puts response.body
  response.success?      # 2xx status
  response.redirect?     # 3xx status
  response.client_error? # 4xx status
  response.server_error? # 5xx status
end
```

If the response body has a JSON content type it will automatically be parsed when requesting the `response.object`:
```ruby
HTTP.get("http://api.example.com/people.json") do |response|
  if response.success?
    response.object["people"].each do |person|
      puts "name: #{person["name"]}"
    end
  else
    puts "Error: #{response.object["errors"]}"
  end
end
```

Use the `follow_redirects` option to specify whether or not to follow redirects. It defaults to true:
```ruby
HTTP.get("http://example.com/redirect", follow_redirects: false) do |response|
  # ...
end
```

When making a `POST` request, specify the `:form` option and it will automatically be encoded as `application/x-www-form-urlencoded` request body:
```ruby
HTTP.post("http://www.example.com/login", form: { user: 'andrew', pass: 'secret'}) do |response|
  if response.success?
    puts "Authenticated!"
  elsif response.client_error?
    puts "Bad username or password"
  else
    puts "Oops! Something went wrong."
  end
end
```

Likewise, to send a JSON encoded request body, use the `:json` option:
```ruby
HTTP.post("http://www.example.com/widgets", json: { widget: { name: "Foobar" } }) do |response|
  if response.success?
    puts "Widget created!"
  elsif response.status_code == 422
    puts "Oops, you did something wrong: #{response.object["error_message"]}"
  else
    puts "Oops! Something went wrong."
  end
end
```

Request specific headers can also be specified with the `:headers` option (overriding any previously set headers):
```ruby
HTTP.post("http://www.example.com/widgets",
    headers: { 'Content-Type' => 'application/vnd.api+json' },
    json: { widget: { name: "Foobar" } }
  ) do |response|
  # ...
end
```

All other HTTP method requests work the same way:
```ruby
HTTP.put(url, params) { ... }
HTTP.patch(url, params) { ... }
HTTP.delete(url, params) { ... }
HTTP.head(url, params) { ... }
HTTP.options(url, params) { ... }
HTTP.trace(url, params) { ... }
```

### Advanced Usage

A common use case is to create a reusable HTTP client that uses a common base URL or request headers.

```ruby
client = HTTP::Client.new("http://api.example.com")
# Set or replace a single header:
client.header "X-API-TOKEN", "abc123xyz"
client.header["X-API-TOKEN"] = "abc123xyz"

# To set or replace multiple headers:
client.headers "X-API-TOKEN" => "abc123xyz",
               "Accept" => "application/json"

# Note that it is valid for some headers to appear multiple times (Accept, Vary, etc).
# To append multiple headers of the same key:
client.add_header "Accept", "application/json"
client.headers.add "Accept", "application/json"
```

Then you can make your requests relative to the base URL that you specified when creating your client.
```ruby
client.get("/people") do |response|
  # ...
end
```

### Basic Auth / Token Auth

To make Basic Auth requests, either set the credentials before the request, or set it on your client:

```ruby
HTTP.basic_auth('username', 'password').get('https://example.com/protected')
# or
client.basic_auth('username', 'password')
client.get('/protected')
```

The `auth` method is another shortcut for setting any value of the Authorization header:

```ruby
HTTP.auth("Token token=#{my_token}")
# or
client.auth("Token token=#{my_token}")
# same as
client.headers['Authorization'] = "Token token=#{my_token}"
```

### Logging

By default, requests and responses will be logged. If you would like to disable this:

```
HTTP.logger.disable!
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## MIT License

Copyright 2018 Andrew Havens

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
