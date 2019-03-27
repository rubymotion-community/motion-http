class Motion
  class HTTP
    class Headers
      def initialize(headers = {})
        @headers = {}
        if headers
          headers.each {|key, value| set(key, value) }
        end
      end

      def get(key)
        @headers[key.downcase]
      end
      # alias :[] :get # FIXME: doesn't work in Android
      def [](key)
        get(key)
      end

      def set(key, value)
        @headers[key.downcase] = value
      end
      # alias :[]= :set # FIXME: doesn't work in Android
      def []=(key, value)
        set(key, value)
      end

      def add(key, value)
        key = key.downcase
        @headers[key] ||= []
        unless @headers[key].is_a?(Array)
          @headers[key] = [@headers[key]]
        end
        @headers[key] << value
      end
      # alias :<< :add # FIXME: doesn't work in Android
      def <<(key, value)
        add(key, value)
      end

      def each(&block)
        @headers.each(&block)
      end

      def to_hash
        @headers # TODO: flatten array values
      end

      # FIXME: Android doesn't support dup (Java exception raised: java.lang.CloneNotSupportedException: Class com.yourcompany.motion_http.Headers doesn't implement Cloneable)
      def dup
        Headers.new(@headers)
      end
    end
  end
end
