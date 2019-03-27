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
    end
  end
end

HTTP = Motion::HTTP # alias as simply HTTP
