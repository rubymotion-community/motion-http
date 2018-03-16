# motion-http

Motion::HTTP is a cross-platform HTTP Client for RubyMotion that's quick and easy to use.

Supported platforms:
- iOS, macOS, tvOS, watchOS
- Android

This gem depends on two really popular networking libraries:
- [AFNetworking](https://github.com/AFNetworking/AFNetworking) (for Cocoa platforms)
- [OkHttp](http://square.github.io/okhttp/) (for Android)

Please note that this library is still a work in progress. Please report bugs and suggestions for improvement!

## Installation

Add this line to your application's Gemfile:

    gem 'motion-http'

And then execute:

    $ bundle
    $ rake pod:install # for iOS apps
    $ rake gradle:install # for Android apps

## Usage

Using `Motion::HTTP` is quick and easy. You can use the simple approach for making one-off requests, or the advanced approach of creating a reusable API client for further customization.

### Simple Usage

The basic syntax for a simple request looks like this:
```ruby
Motion::HTTP.method(url, params) do |response|
  # this block will be called asynchronously
end
```

To make a simple `GET` request:
```ruby
Motion::HTTP.get("http://www.example.com") do |response|
  puts "status code: #{response.status_code}"
  puts "response body: #{response.body}"
  if response.success?
    puts "Success!"
  else
    puts "Oops! Something went wrong."
  end
end
```

You can specify query params as the second argument:
```ruby
Motion::HTTP.get("http://www.example.com/search", term: "my search term") do |response|
  # ...
end
```

`Motion::HTTP` will automatically parse JSON responses:
```ruby
Motion::HTTP.get("http://api.example.com/people.json") do |response|
  if response.success?
    response.object["people"].each do |person|
      puts "name: #{person["name"]}"
    end
  else
    puts "Error: #{response.object["errors"]}"
  end
end
```

To make a simple `POST` request, the value passed as the second argument will be encoded as the request body:
```ruby
json = { widget: { name: "Foobar" } }
Motion::HTTP.post("http://www.example.com/widgets", json) do |response|
  if response.success?
    puts "Widget created!"
  elsif response.client_error?
    puts "Oops, you did something wrong: #{response.object["error_message"]}"
  else
    puts "Oops! Something else went wrong."
  end
end
```

`PUT`, `PATCH`, and `DELETE` requests work the same way:
```ruby
Motion::HTTP.put(url, params) { ... }
Motion::HTTP.patch(url, params) { ... }
Motion::HTTP.delete(url, params) { ... }
```

### Advanced Usage

A common use case is to create a reusable HTTP client that uses a common base URL or request headers.

```ruby
client = Motion::HTTPClient.new("http://www.example.com")
# Set or replace a header
client.header "X-API-TOKEN", "abc123xyz"
# It is valid for some headers to appear multiple times (Accept, Vary, etc).
# Use add_header to append multiple headers of the same name.
client.add_header "Accept", "application/json"
client.add_header "Accept", "application/vnd.api+json"
```

Then make your requests relative to the base URL that you specified when creating your client.
```ruby
client.get("/people") do |response|
  # ...
end
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
