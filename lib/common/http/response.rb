class Motion
  class HTTP
    class Response
      attr_reader :status_code, :headers, :body, :object

      def initialize(status_code, headers, body_string, body_object = nil)
        @status_code = status_code
        @headers = headers
        @body = body_string
        @object = body_object
      end

      def success?
        return false unless status_code
        status_code >= 200 && status_code < 300
      end

      def inspect
        "<Motion::HTTP::Response status_code:#{status_code} headers:<#{headers.class}> body:<#{body.class}>>"
      end
    end
  end
end
