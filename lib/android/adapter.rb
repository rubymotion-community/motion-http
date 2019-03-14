class Motion
  class HTTP
    class Adapter
      JSONMediaType = Okhttp3::MediaType.parse("application/json; charset=utf-8")

      def self.client
        @client ||= Okhttp3::OkHttpClient.new
      end

      def self.perform(request, &callback)
        http_method = request.http_method
        url = request.url
        headers = request.headers
        params = request.params

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
        client.newCall(request.build).enqueue(OkhttpCallback.new(request, callback))
      end

      class OkhttpCallback
        def initialize(request, callback)
          @request = request
          @callback = callback
        end

        def onFailure(call, e)
          puts "Error: #{e.getMessage}"
          @callback.call(Response.new(@request, nil, Headers.new, e.getMessage))
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
          Response.new(@request, response.code, headers, response.body.string)
        end
      end
    end
  end
end
