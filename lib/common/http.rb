class Motion
  class HTTP
    class << self
      def client
        @client ||= Client.new
      end

      # FIXME: doesn't work on Android
      # [:get, :post, :put, :patch, :delete].each do |method|
      #   define_method "#{method}", do |url, params = nil, &callback|
      #     client.send(method, url, params, &callback)
      #   end
      # end

      def get(url, params = nil, &callback)
        client.get(url, params, &callback)
      end

      def post(url, params = nil, &callback)
        client.post(url, params, &callback)
      end

      def put(url, params = nil, &callback)
        client.put(url, params, &callback)
      end

      def patch(url, params = nil, &callback)
        client.patch(url, params, &callback)
      end

      def delete(url, params = nil, &callback)
        client.delete(url, params, &callback)
      end
    end
  end
end
