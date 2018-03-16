class Motion
  class HTTP
    class Adapter
      def self.manager
        @manager ||= AFHTTPSessionManager.manager
      end

      def self.request(http_method, url, headers, params = nil, &callback)
        progress = nil
        on_success = lambda do |task, response_object|
          response = task.response
          callback.call(Response.new(response.statusCode, Headers.new(response.allHeaderFields), nil, response_object))
        end
        on_error = lambda do |operation, error|
          NSLog("Error: %@", error)
          response = operation.response
          status_code = response.statusCode if response
          response_headers = response.allHeaderFields if response
          error_message = error.localizedDescription
          error_message += error.userInfo[NSLocalizedDescriptionKey] if error.userInfo[NSLocalizedDescriptionKey]
          callback.call(
            Response.new(status_code, Headers.new(response_headers), error_message)
          )
        end

        case http_method
        when :get
          manager.GET url, parameters: params, progress: progress, success: on_success, failure: on_error
        when :post
          manager.POST url, parameters: params, progress: progress, success: on_success, failure: on_error
        when :put
          manager.PUT url, parameters: params, progress: progress, success: on_success, failure: on_error
        when :patch
          manager.PATCH url, parameters: params, progress: progress, success: on_success, failure: on_error
        when :delete
          manager.DELETE url, parameters: params, progress: progress, success: on_success, failure: on_error
        end

        # FIXME: dynamically calling the method using send results in a crash
        # method_signature = "#{http_method.to_s.upcase}:parameters:progress:success:failure:"
        # # manager.send(method_signature, url, params, nil, on_success, on_error)
      end
    end
  end
end
