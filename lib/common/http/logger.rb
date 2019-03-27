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

      def log(message, color = :white)
        puts colorize(color, message) if enabled
      end

      def error(message)
        puts colorize(:red, message)
      end

      def log_request(request)
        log "\nRequest:\n#{request.http_method.to_s.upcase} #{request.url}", :dark_gray

        if request.headers
          request.headers.each do |k,v|
            log "#{k}: #{v}", :dark_gray
          end
        end

        log(request.body, :dark_gray) if request.body
      end

      def log_response(response)
        log "\nResponse:", :dark_gray
        if response.original_request
          log "URL: #{response.original_request.url}", :dark_gray
        end
        log "Status: #{response.status_code}", :dark_gray
        response.headers.each do |k,v|
          log "#{k}: #{v}", :dark_gray
        end
        log "\n#{response.body}", :dark_gray
      end

      def colorize(color, string)
        return string unless simulator? # Only colorize in the simulator

        code = {
          red: 31,
          dark_gray: 90,
        }[color]

        if code
          "\e[#{code}m#{string}\e[0m"
        else
          string
        end
      end

      # Copied from https://github.com/rubymotion/BubbleWrap/blob/8eaf99a0966f2b375e774f5940279a704c10ad29/motion/core/ios/device.rb#L46
      def simulator?
        @simulator_state ||= begin
          if !defined?(NSObject) # android
            false
          elsif ios_version.to_i >= 9
            !NSBundle.mainBundle.bundlePath.start_with?('/var/')
          else
            !(UIDevice.currentDevice.model =~ /simulator/i).nil?
          end
        end
      end
    end
  end
end
