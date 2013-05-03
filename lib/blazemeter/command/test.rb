require 'blazemeter/utils'

class Blazemeter
class Command
class Test < Command # :nodoc:
extend Blazemeter::Utils


def cmd_create argv
   options = Hash.new
   options["options"] = Hash.new

   begin
     user_key = Blazemeter::Command::API.get_user_key
	 vars = Blazemeter::Command::Test.parse argv
	 blaze = BlazemeterApi.new(user_key)
	 blaze.testCreate(vars["test_name"], vars["max_users"], vars["location"])
    rescue "help"
      return help
    end
  end
  
  def cmd_start argv
	begin
     user_key = Blazemeter::Command::API.get_user_key
	 vars = Blazemeter::Command::Test.parse argv
	 blaze = BlazemeterApi.new(user_key)
	 blaze.testStart(vars["test_id"])
    rescue "help"
      return help
    end
  end
  
  def cmd_stop argv
    begin
     user_key = Blazemeter::Command::API.get_user_key
	 vars = Blazemeter::Command::Test.parse argv
	 blaze = BlazemeterApi.new(user_key)
	 blaze.testStop(vars["test_id"])
    rescue "help"
      return help
    end
  end
  
  def cmd_update argv
    begin
     user_key = Blazemeter::Command::API.get_user_key
	 vars = Blazemeter::Command::Test.parse argv
	 blaze = BlazemeterApi.new(user_key)
	 blaze.testUpdate(vars["test_id"], vars["max_users"], vars["location"])
    rescue "help"
      return help
    end
  end
  
  def cmd_status argv
    begin
     user_key = Blazemeter::Command::API.get_user_key
	 vars = Blazemeter::Command::Test.parse argv
	 blaze = BlazemeterApi.new(user_key)
	 blaze.testGetStatus(vars["test_id"])
    rescue "help"
      return help
    end
  end
  
  def self.parse arguments
        argv = arguments.is_a?(Array) ? arguments : ''
        args = parse_cli argv
        raise "help" if args['help']

        args		
  end
  
   def self.parse_cli argv
        hash = { 'steps' => [] }

        while not argv.empty?
            hash['steps'] << Hash.new
            step = hash['steps'].last

            while not argv.empty?
                break if argv.first[0,1] != '-'

                k = argv.shift
                if ['-u'].member? k
                    hash['max_users'] = shift(k, argv)
                    next
                end
				if ['-n'].member? k
                    hash['test_name'] = shift(k, argv)
                    next
                end
				if ['-l'].member? k
                    hash['location'] = shift(k, argv)
                    next
                end
				if ['-i'].member? k
                    hash['test_id'] = shift(k, argv)
                    next
                end
				
				raise ArgumentError, "Unknown option #{k}"
			end	
		  break if hash['help']
		end
		if not hash['help']
            if hash['steps'].empty?
                raise ArgumentError, "no options specified!"
            end
        end

        hash
    end		
	
end
end # Command
end # Blazemeter