class Motion
  class HTTP
    class Adapter
      JSONMediaType = Okhttp3::MediaType.parse("application/json; charset=utf-8")

      def self.client
        @client ||= Okhttp3::OkHttpClient.new
      end

      def self.request(http_method, url, headers, params = nil, &callback)
        puts "starting #{http_method.to_s.upcase} #{url}"
        request = OkHttp3::Request::Builder.new
        request.url(url) # TODO: encode GET params and append to URL prior to calling this method
        headers.each do |key, value|
          if value.is_a? Array
            value.each {|val| request.addHeader(key, val) }
          else
            request.header(key, value)
          end
        end
        if http_method != :get
          puts "would have set body for #{http_method.to_s.upcase} #{url}"
          # body = OkHttp3::RequestBody.create(JSONMediaType, params) # TODO: allow other content types
          # request.method(http_method.to_s, body)
        end
        client.newCall(request.build).enqueue(OkhttpCallback.new(callback))
      end

      class OkhttpCallback
        def initialize(callback)
          @callback = callback
        end

        def onFailure(call, e)
          puts "Error: #{e.getMessage}"
          @callback.call(Response.new(nil, Headers.new, e.getMessage))
        end

        def onResponse(call, response)
          @callback.call(parse_response(response))
        end

        def parse_response(response)
          headers = Headers.new
          i = 0
          while i < response.headers.size
            key = response.headers.name(i)
            value = response.headers.value(i)
            headers.add(key, value)
            i += 1
          end
          body_string = response.body.string
          json = JSON.load(body_string) if headers['content-type'] =~ /application\/json/
          Response.new(response.code, headers, body_string, json)
        end
      end
    end
  end
end
