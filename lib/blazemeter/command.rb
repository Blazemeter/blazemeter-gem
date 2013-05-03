require 'blazemeter/utils'
class Blazemeter
class Command # :nodoc:
include Blazemeter::Utils
end
end # Blazemeter

Dir["#{File.dirname(__FILE__)}/command/*.rb"].each { |c| require c }
