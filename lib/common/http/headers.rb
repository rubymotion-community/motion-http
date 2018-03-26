class Motion
  class HTTP
    class Headers
      def initialize(headers = {})
        @headers = headers
      end

      def set(key, value)
        @headers[key.downcase] = value
      end

      def add(key, value)
        key = key.downcase
        @headers[key] ||= []
        unless @headers[key].is_a?(Array)
          @headers[key] = [@headers[key]]
        end
        @headers[key] << value
      end

      def each(&block)
        @headers.each(&block)
      end

      def [](key)
        @headers[key.downcase]
      end
    end
  end
end
