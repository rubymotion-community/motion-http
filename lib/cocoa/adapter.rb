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
          if @request.options[:download]
            perform_download_request(ns_url_request, &callback)
          else
            perform_normal_http_request(ns_url_request, &callback)
          end
        end

        def perform_download_request(ns_url_request, &callback)
          # TODO: need to set up delegate methods when using a background session
          # @background_session = NSURLSession.sessionWithConfiguration(NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("motion-http"))
          # task = @background_session.downloadTaskWithRequest(ns_url_request, completionHandler: -> (location, response, error) {
          task = @session.downloadTaskWithRequest(ns_url_request, completionHandler: -> (location, response, error) {
            if error
              log_error "Error while requesting #{@request.url}: #{error_description(error)}"
              response = Response.new(@request, response&.statusCode, Headers.new(response&.allHeaderFields), error_description(error))
            else
              if @request.options[:to]
                error_ptr = Pointer.new(:object)
                file_data = NSFileManager.defaultManager.contentsAtPath(location)
                file_data.writeToFile(@request.options[:to], options: NSDataWritingAtomic, error: error_ptr)

                if error_ptr[0]
                  log_error "Error while saving downloaded file: #{error_description(error_ptr[0])}"
                  response = Response.new(@request, response.statusCode, Headers.new(response.allHeaderFields), error_description(error_ptr[0]))
                else
                  response = Response.new(@request, response.statusCode, Headers.new(response.allHeaderFields), nil)
                end
              else
                log_error "No local save path specified."
              end
              Motion::HTTP.logger.log_response(response)
            end
            callback.call(response) if callback
          })
          task.resume
        end

        def perform_normal_http_request(ns_url_request, &callback)
          task = @session.dataTaskWithRequest(ns_url_request, completionHandler: -> (data, response, error) {
            if error
              log_error "Error while requesting #{@request.url}: #{error_description(error)}"
              response = Response.new(@request, response&.statusCode, Headers.new(response&.allHeaderFields), error_description(error))
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

        def log_error(message, error = nil)
          Motion::HTTP.logger.error(message)
        end

        def error_description(error)
          "#{error.localizedDescription} #{error.userInfo['NSLocalizedDescriptionKey']}"
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
