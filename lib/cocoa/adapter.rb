class Motion
  class HTTP
    class Adapter
      def self.perform(request, &callback)
        Motion::HTTP::Adapter::Request.new(request).perform(&callback)
      end

      class Request
        def initialize(request)
          @request = request
          @session = NSURLSession.sessionWithConfiguration(NSURLSessionConfiguration.defaultSessionConfiguration, delegate: self, delegateQueue: nil)
        end

        def perform(&callback)
          # TODO: dataTask is good for general HTTP requests but not for file downloads
          ns_url_request = build_ns_url_request
          task = @session.dataTaskWithRequest(ns_url_request, completionHandler: -> (data, response, error) {
            if error
              error_message = "#{error.localizedDescription} #{error.userInfo['NSLocalizedDescriptionKey']}"
              Motion::HTTP.logger.error("Error while requesting #{@request.url}: #{error_message}")
              response = Response.new(@request, response&.statusCode, Headers.new(response&.allHeaderFields), error_message)
            else
              response = Response.new(@request, response.statusCode, Headers.new(response.allHeaderFields), data.to_s)
              Motion::HTTP.logger.log_response(response)
            end
            callback.call(response) if callback
          })
          task.resume
        end

        def build_ns_url_request
          ns_url_request = NSMutableURLRequest.alloc.initWithURL(NSURL.URLWithString(@request.url))
          ns_url_request.HTTPMethod = @request.http_method.to_s.upcase
          @request.headers.each do |key, value|
            if value.is_a? Array
              value.each {|v2| ns_url_request.addValue(v2, forHTTPHeaderField: key) }
            else
              ns_url_request.setValue(value, forHTTPHeaderField: key)
            end
          end

          if @request.body
            if @request.body.is_a?(NSData)
              body_data = @request.body
            else
              body_data = NSString.alloc.initWithString(@request.body).dataUsingEncoding(NSUTF8StringEncoding)
            end
            ns_url_request.HTTPBody = body_data
          end

          # TODO: add other headers
          ns_url_request
        end

        # NSURLSessionTaskDelegate methods

        def URLSession(session, task: task, willPerformHTTPRedirection: response, newRequest: request, completionHandler: completion_handler)
          if @request.options[:follow_redirects] == false
            completion_handler.call(nil)
          else
            completion_handler.call(request)
          end
        end
      end
    end
  end
end
