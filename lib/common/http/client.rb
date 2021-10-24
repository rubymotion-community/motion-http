class Motion
  class HTTP
    class Client
      attr_reader :base_url

      def initialize(base_url = nil, options = nil)
        @base_url = base_url || ''
        options ||= {}
        @headers = Headers.new(options.delete(:headers))
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

      def basic_auth(username, password)
        header_value = 'Basic ' + Base64.encode("#{username}:#{password}")
        auth(header_value)
        self
      end

      def auth(header_value)
        @headers.set 'Authorization', header_value
        self
      end

      def get(path, options = nil, &callback)
        request(:get, path, options, &callback)
      end

      def post(path, options = nil, &callback)
        request(:post, path, options, &callback)
      end

      def put(path, options = nil, &callback)
        request(:put, path, options, &callback)
      end

      def patch(path, options = nil, &callback)
        request(:patch, path, options, &callback)
      end

      def delete(path, options = nil, &callback)
        request(:delete, path, options, &callback)
      end

      def head(path, options = nil, &callback)
        request(:head, path, options, &callback)
      end

      def options(path, options = nil, &callback)
        request(:options, path, options, &callback)
      end

      def trace(path, options = nil, &callback)
        request(:trace, path, options, &callback)
      end

      def download(remote_path, options = nil, &callback)
        options ||= {}
        http_method = options[:method] || :get
        options[:download] = true
        request(http_method, remote_path, options, &callback)
      end

      def request(http_method, path, options = nil, &callback)
        options ||= {}
        headers_dup = headers.dup
        if options[:headers]
          options.delete(:headers).each {|key, value| headers_dup.set(key, value) }
        end
        options[:headers] = headers_dup
        Request.new(http_method, base_url + path, options).perform(&callback)
      end
    end
  end
end
