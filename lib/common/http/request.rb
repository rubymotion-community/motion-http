class Motion
  class HTTP
    class Request
      attr_reader :http_method, :url, :headers, :body, :options

      def initialize(http_method, url, options = nil)
        @http_method = http_method
        @url = url
        @options = options ||= {}
        @headers = @options.delete(:headers) || Headers.new
        @body = @options.delete(:body)

        if @options[:params]
          @params = @options.delete(:params)
          flatten_params!
          encode_params!
          @url = "#{url}?#{@params.map{|k,v|"#{k}=#{v}"}.join('&')}"

        elsif @options[:form]
          @headers['Content-Type'] ||= 'application/x-www-form-urlencoded'
          @params = @options.delete(:form)
          flatten_params!
          encode_params!
          @body = @params.map{|k,v|"#{k}=#{v}"}.join('&')

        elsif @options[:json]
          @headers['Content-Type'] ||= 'application/json; charset=utf-8'
          @body = @options.delete(:json).to_json
        end
      end

      def flatten_params!
        new_params = {}
        @params.each do |k,v|
          if v.is_a? Hash
            v.each do |nested_k, nested_v|
              new_params["#{k}[#{nested_k}]"] = nested_v
            end
          else
            new_params[k] = v
          end
        end
        @params = new_params
        flatten_params! if @params.any? {|k,v| v.is_a? Hash }
      end

      def encode_params!
        new_params = {}
        @params.each do |k,v|
          new_params[ParamsEncoder.encode(k)] = ParamsEncoder.encode(v)
        end
        @params = new_params
      end

      def perform(&callback)
        Motion::HTTP.logger.log_request(self)
        Adapter.perform(self, &callback)
      end
    end
  end
end
