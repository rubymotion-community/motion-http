class Motion
  class HTTP
    class Client
      attr_reader :base_url, :headers

      def initialize(base_url = nil)
        @base_url = base_url || ""
        @headers = Headers.new
      end

      def header(key, value)
        headers.set(key, value)
      end

      def add_header(key, value)
        headers.add(key, value)
      end

      # FIXME: doesn't work on Android
      # [:get, :post, :put, :patch, :delete].each do |method|
      #   define_method "#{method}", do |path, params = nil, &callback|
      #     Request.new(method, base_url + path, headers, params, &callback).call
      #   end
      # end

      def get(path, params = nil, &callback)
        Request.new(:get, base_url + path, headers, params, &callback).call
      end

      def post(path, params = nil, &callback)
        Request.new(:post, base_url + path, headers, params, &callback).call
      end
    end
  end
end
