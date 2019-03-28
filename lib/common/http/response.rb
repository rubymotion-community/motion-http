class Motion
  class HTTP
    class Response
      attr_reader :original_request, :status_code, :headers, :body

      def initialize(original_request, status_code, headers, body)
        @original_request = original_request
        @status_code = status_code
        @headers = headers
        @body = body
      end

      def success?
        status_code && (200..299) === status_code
      end

      def redirect?
        status_code && (300..399) === status_code
      end

      def client_error?
        status_code && (400..499) === status_code
      end

      def server_error?
        status_code && (500..599) === status_code
      end

      def object
        @object ||= case headers['Content-Type']
          when /^application\/json/, /^application\/vnd.api\+json/
            JSON.parse(body)
          else
            body
          end
      end

      def inspect
        "<Motion::HTTP::Response status_code:#{status_code} headers:#{headers.inspect} body:#{body.inspect}>"
      end
    end
  end
end
