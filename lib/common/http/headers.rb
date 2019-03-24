class Motion
  class HTTP
    class Headers
      def initialize(headers = {})
        @headers = {}
        if headers.is_a? Hash
          headers.each {|key, value| set(key, value) }
        end
      end

      def get(key)
        @headers[key.downcase]
      end
      alias :[] :get

      def set(key, value)
        @headers[key.downcase] = value
      end
      alias :[]= :set

      def add(key, value)
        key = key.downcase
        @headers[key] ||= []
        unless @headers[key].is_a?(Array)
          @headers[key] = [@headers[key]]
        end
        @headers[key] << value
      end
      alias :<< :add

      def each(&block)
        @headers.each(&block)
      end
    end
  end
end
