require 'java'

module RubyJMX
  include_class 'java.util.HashMap'
  
  class Session
    include_package 'java.lang.management'
    include_package 'javax.management'
    include_package 'javax.management.remote'
    
    attr_accessor :host, :port, :username, :password
    
    def initialize(host, port, opts = {})
      raise ArgumentError, 'You must specify a valid host and port' if(host.nil? || port.nil?)
      
      self.host, self.port = host, port
      self.username, self.password = opts[:username], opts[:password]

      connect_to_jmx if opts[:connect]
      
      yield self if block_given?
    end
      
    def heap_memory_snapshot
      raise ArgumentError, 'You do not seem to be connected' if @mbean_server_connection.nil?
      # First get the bean,
      memory_mbean = get_bean_from("java.lang:type=Memory")
      # Then the snapshot object from the bean
      usage_snapshot = memory_mbean.get_heap_memory_usage
      # Return the object
      return RubyJmx::HeapMemorySnapShot.new(usage_snapshot.get_committed, usage_snapshot.get_init,
                                              usage_snapshot.get_max, usage_snapshot.get_used)
    end
      

    def connect_to_jmx
      jmx_env = setup_jmx_environment
      connector = JMXConnectorFactory::connect(JMXServiceURL.new("service:jmx:rmi:///jndi/rmi://" + 
                                                "#{host}:#{port}/jmxrmi"),
                                                jmx_env)
      @mbean_server_connection = connector.mbean_server_connection 
    end

private
    def get_bean_from(description)
      return nil if description.nil? || description.length == 0
      ManagementFactory::newPlatformMXBeanProxy(@mbean_server_connection, description, 
                                                MemoryMXBean::java_class)
    end  

    def setup_jmx_environment
      jmx_env = HashMap.new

      unless username.nil? || password.nil?
        credentials = [username, password].to_java(:string)
        jmx_env.put('jmx.remote.credentials', credentials)
      end

      jmx_env
    end
  end
end