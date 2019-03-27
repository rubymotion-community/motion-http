class Motion
  class HTTP
    class Adapter
      def self.perform(request, &callback)
        volley_request = VolleyRequest.create(request, callback)
        queue.add(volley_request)
      end

      def self.queue
        @queue ||= Com::Android::Volley::Toolbox::Volley.newRequestQueue(Motion::HTTP.application_context)
      end
    end
  end
end
