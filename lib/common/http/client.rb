class Motion
  class HTTP
    class Client
      attr_reader :base_url

      def initialize(base_url = nil)
        @base_url = base_url || ''
        @headers = Headers.new
      end

      def header(key, value)
        @headers.set(key, value)
      end

      def add_header(key, value)
        @headers.add(key, value)
      end

      def headers(hash = nil)
        if hash
          hash.each do |key, value|
            @headers.set(key, value)
          end
        end
        @headers
      end

      # FIXME: doesn't work on Android for some reason
      # [:get, :post, :put, :patch, :delete].each do |method|
      #   define_method "#{method}", do |path, params = nil, options = nil, &callback|
      #     Request.new(method, base_url + path, headers, params, options).perform(&callback)
      #   end
      # end

      def get(path, params = nil, options = nil, &callback)
        Request.new(:get, base_url + path, headers, params, options).perform(&callback)
      end

      def post(path, params = nil, options = nil, &callback)
        Request.new(:post, base_url + path, headers, params, options).perform(&callback)
      end

      def put(path, params = nil, options = nil, &callback)
        Request.new(:put, base_url + path, headers, params, options).perform(&callback)
      end

      def patch(path, params = nil, options = nil, &callback)
        Request.new(:patch, base_url + path, headers, params, options).perform(&callback)
      end

      def delete(path, params = nil, options = nil, &callback)
        Request.new(:delete, base_url + path, headers, params, options).perform(&callback)
      end
    end
  end
end
