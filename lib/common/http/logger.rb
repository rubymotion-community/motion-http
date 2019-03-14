class Motion
  class HTTP
    class Logger
      def log(message)
        puts message # TODO: add option to enable/disable logging
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
