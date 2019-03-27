class VolleyRequest < Com::Android::Volley::Request
  attr_accessor :original_request, :callback

  METHOD_CODES = {
    get: 0,
    post: 1,
    put: 2,
    delete: 3,
    head: 4,
    options: 5,
    trace: 6,
    patch: 7,
  }

  def self.create(request, callback)
    volley_request = new(METHOD_CODES[request.http_method], request.url, nil)
    volley_request.original_request = request
    volley_request.headers = request.headers.to_hash
    volley_request.body = request.body
    volley_request.callback = callback
    volley_request
  end

  def parseNetworkResponse(networkResponse)
    response = build_response(networkResponse)
    Com::Android::Volley::Response.success(response, Com::Android::Volley::Toolbox::HttpHeaderParser.parseCacheHeaders(networkResponse))
  end

  def deliverResponse(response)
    Motion::HTTP.logger.log_response(response)
    callback.call(response) if callback
  end

  def deliverError(error)
    if error.networkResponse
      response = build_response(error.networkResponse)
      deliverResponse(response)
    else
      Motion::HTTP.logger.error("Error while requesting #{original_request.url}: #{error.getMessage}")
      error.getStackTrace.each do |line|
        puts line.toString
      end
      response = Motion::HTTP::Response.new(original_request, nil, nil, error.getMessage)
      callback.call(response) if callback
    end
  end

  def build_response(networkResponse)
    body = parse_body_from_response(networkResponse)
    Motion::HTTP::Response.new(original_request, networkResponse.statusCode, Motion::HTTP::Headers.new(networkResponse.headers), body)
  end
end
