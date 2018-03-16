class Motion
  class HTTP
    class Request
      attr_reader :method, :url, :headers, :body, :callback

      def initialize(method, url, headers = nil, params = nil, &callback)
        @method = method
        @url = url
        @headers = headers || Headers.new
        @body = params # TODO: turn params into body and set content-type?
        @callback = callback || ->(response) {}
      end

      def call
        # TODO: maybe pass self instead of args
        Adapter.request(method, url, headers, body, &callback)
      end
    end
  end
end
