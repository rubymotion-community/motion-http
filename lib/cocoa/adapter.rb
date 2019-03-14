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
              NSLog("Error: %@", error) # TODO: use configurable logging
              error_message = error.localizedDescription
              error_message += error.userInfo[NSLocalizedDescriptionKey] if error.userInfo[NSLocalizedDescriptionKey]
              response = Response.new(@request, response.statusCode, Headers.new(response.allHeaderFields), error_message)
            else
              response = Response.new(@request, response.statusCode, Headers.new(response.allHeaderFields), data.to_s)
            end
            Motion::HTTP.logger.log_response(response)
            callback.call(response)
          })
          task.resume
        end

        def build_ns_url_request
          ns_url_request = NSMutableURLRequest.alloc.initWithURL(NSURL.URLWithString(@request.url))
          ns_url_request.HTTPMethod = @request.http_method.to_s.upcase
          if @request.params
            # TODO: json serialization
            ns_url_request.setValue('application/x-www-form-urlencoded', forHTTPHeaderField: 'Content-Type')
            ns_url_request.HTTPBody = FormDataSerializer.serialize(@request.params).dataUsingEncoding(NSUTF8StringEncoding)
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
