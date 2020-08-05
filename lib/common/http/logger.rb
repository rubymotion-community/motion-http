class Motion
  class HTTP
    class Logger
      attr_reader :enabled

      def initialize(enabled = true)
        # TODO: add ability to configure amount of logging (i.e. request URL only, no body, etc)
        @enabled = enabled
      end

      def enable!
        @enabled = true
      end

      def disable!
        @enabled = false
      end

      def _logger
        @_logger ||= Motion::Lager.new
      end

      def debug(message, color = :gray)
        _logger.debug(message, color) if enabled
      end

      def log(message, color = :white)
        _logger.log(message, color) if enabled
      end

      def error(message, color = :red)
        _logger.error(message, color) # always log even if logging is disabled
      end

      def log_request(request)
        debug "\nRequest:\n#{request.http_method.to_s.upcase} #{request.url}"
        request.headers.each do |k,v|
          debug "#{k}: #{v}"
        end
        debug(request.body) if request.body
      end

      def log_response(response)
        debug "\nResponse:"
        if response.original_request
          debug "URL: #{response.original_request.url}"
        end
        debug "Status: #{response.status_code}"
        response.headers.each do |k,v|
          debug "#{k}: #{v}"
        end
        debug("\n#{response.body}")
      end

    end
  end
end
