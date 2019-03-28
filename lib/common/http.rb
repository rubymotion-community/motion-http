class Motion
  class HTTP
    class << self
      attr_accessor :application_context # Android

      def logger
        @logger ||= Logger.new
      end

      def client(*args)
        Client.new(*args)
      end

      def basic_auth(username, password)
        client.basic_auth(username, password)
      end

      def auth(header_value)
        client.auth(header_value)
      end

      def get(url, options = nil, &callback)
        client.get(url, options, &callback)
      end

      def post(url, options = nil, &callback)
        client.post(url, options, &callback)
      end

      def put(url, options = nil, &callback)
        client.put(url, options, &callback)
      end

      def patch(url, options = nil, &callback)
        client.patch(url, options, &callback)
      end

      def delete(url, options = nil, &callback)
        client.delete(url, options, &callback)
      end

      def head(url, options = nil, &callback)
        client.head(url, options, &callback)
      end

      def options(url, options = nil, &callback)
        client.options(url, options, &callback)
      end

      def trace(url, options = nil, &callback)
        client.trace(url, options, &callback)
      end
    end
  end
end

HTTP = Motion::HTTP # alias as simply HTTP
