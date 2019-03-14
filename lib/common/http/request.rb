class Motion
  class HTTP
    class Request
      attr_reader :http_method, :url, :headers, :params, :options

      def initialize(http_method, url, headers = nil, params = nil, options = nil)
        @http_method = http_method
        @url = url
        @headers = headers || Headers.new
        @params = params
        @options = options
      end

      def perform(&callback)
        Motion::HTTP.logger.log_request(self)
        Adapter.perform(self, &callback)
      end
    end
  end
end
