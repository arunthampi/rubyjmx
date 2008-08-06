require 'lib/rubyjmx'

RubyJMX::Session.new('localhost', '3000',
                      :username => 'username',
                      :password => 'password', 
                      :connect => true) do |session|
  puts "Memory Used is #{session.heap_memory_snapshot.used}"
end