class Motion
  class HTTP
    class Logger
      attr_reader :enabled

      def initialize(enabled = true)
        @enabled = enabled
      end

      def enable!
        @enabled = true
      end

      def disable!
        @enabled = false
      end

      def log(message)
        puts message if enabled
      end

      def log_request(request)
        log "Request:\n#{request.http_method.to_s.upcase} #{request.url}"

        if request.headers
          request.headers.each do |k,v|
            log "#{k}: #{v.inspect}"
          end
        end

        if request.params
          # log serialized_params
          request.params.each do |k,v|
            log "\t#{k}=#{v.inspect}"
          end
        end
        log "\n"
      end

      def log_response(response)
        log "Response:"
        log "URL: #{response.original_request.url}"
        log "Status: #{response.status_code}"
        response.headers.each do |key, value|
          log "#{key}: #{value}"
        end
        log "\n#{response.body}"
      end
    end
  end
end
