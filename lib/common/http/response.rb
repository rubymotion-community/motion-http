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
        return false unless status_code
        status_code >= 200 && status_code < 300
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
