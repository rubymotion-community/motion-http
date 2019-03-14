class Motion
  class HTTP
    class << self
      def logger
        @logger ||= Logger.new
      end

      def client
        @client ||= Client.new
      end

      # FIXME: doesn't work on Android
      # [:get, :post, :put, :patch, :delete].each do |method|
      #   define_method "#{method}", do |url, params = nil, options = nil, &callback|
      #     client.send(method, url, params, options, &callback)
      #   end
      # end

      def get(url, params = nil, options = nil, &callback)
        client.get(url, params, options, &callback)
      end

      def post(url, params = nil, options = nil, &callback)
        client.post(url, params, options, &callback)
      end

      def put(url, params = nil, options = nil, &callback)
        client.put(url, params, options, &callback)
      end

      def patch(url, params = nil, options = nil, &callback)
        client.patch(url, params, options, &callback)
      end

      def delete(url, params = nil, options = nil, &callback)
        client.delete(url, params, options, &callback)
      end
    end
  end
end

HTTP = Motion::HTTP # alias as simply HTTP
