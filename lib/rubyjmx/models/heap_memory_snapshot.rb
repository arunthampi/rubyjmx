module RubyJMX
  # Defines a HeapMemorySnapShot class which is used to describe encapsulate the response
  # which comes from JMX
  class HeapMemorySnapShot
    attr_reader :committed, :init, :max, :used
    
    def initialize(committed = 0, init = 0, max = 0, used = 0)
      # Initialize all values to zero
      @committed, @init, @max, @used = committed.to_i, init.to_i, max.to_i, used.to_i
    end
    
    def to_s
      "Committed: #{@committed} bytes, Init: #{@init} bytes, Max: #{@max} bytes, Used: #{@used} bytes"
    end
  end
end