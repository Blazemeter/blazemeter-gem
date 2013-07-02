require 'blazemeter/utils'

class Blazemeter
class Command
class Test < Command # :nodoc:
extend Blazemeter::Utils


def cmd_create argv
   options = Hash.new
   options["options"] = Hash.new

   begin
     user_key = Blazemeter::Common.get_user_key
	 if !user_key
	   puts "You must enter API Key. Use blazemeter api:init"
	   return
	 end
	 vars = Blazemeter::Command::Test.parse argv
	 
	 vars["options"]["TEST_TYPE"] = "jmeter" #hardcoded until next version
	 #todo: check if this can be on even if we don't override anything
	 #todo: move to blazemeter.rb
	 vars["options"]["OVERRIDE"] = 1 #turn on overriding
	 
	 if !vars["test_name"]
       puts "Enter name for the test: "
	   user_input = gets
	   if user_input.chomp != ""
	     vars["test_name"] = user_input.chomp
	   end
     end

   if !vars["options"]["LOCATION"]
     puts "Enter location(Default - Virginia, California, Oregon, Ireland, Sydney, Tokyo, Singapore, Sao Paulo): "
	 user_input = gets
	 if user_input.chomp != ""
	   vars["options"]["LOCATION"] = user_input.chomp
	 end
   end
   
   if !vars["jmx_filepath"]
       puts "Enter a path to a JMX file:* "
	   user_input = gets.chomp
	   while user_input.empty? || !File.exist?(user_input) do
	     if !user_input.empty? && !File.exist?(user_input)
		   puts "File doesn't exist. Please enter absolute path, or relative to the "+Dir.pwd
		 end
		 puts "* mandatory field."
	     puts "Enter a path to a JMX file:* "
         user_input = gets.chomp
	   end 
	   vars["jmx_filepath"] = user_input
   end
   
   if !vars["options"]["JMETER_VERSION"]
     puts "Enter Jmeter version(Default - 2.9, 2.8, 2.7, 2.6, 2.5, 2.4, 2.3.2): "
	 user_input = gets
	 if user_input.chomp != ""
	   vars["options"]["JMETER_VERSION"] = user_input.chomp.to_f
	 end
   end
   
   if !vars["options"]["OVERRIDE_RAMP_UP"]
     puts "Enter ramp up(300sec): "
	 user_input = gets
	 if user_input.chomp != ""
	   vars["options"]["OVERRIDE_RAMP_UP"] = user_input.chomp.to_i
	 end
   end
   
   if !vars["options"]["OVERRIDE_ITERATIONS"]
     puts "Enter iterations(forever): "
	 user_input = gets
	 if user_input.chomp != ""
	   vars["options"]["OVERRIDE_ITERATIONS"] = user_input.chomp.to_i
	 end
   end
   
   if !vars["options"]["OVERRIDE_DURATION"]
     puts "Enter duration(forever): "
	 user_input = gets
	 if user_input.chomp != ""
	   vars["options"]["OVERRIDE_DURATION"] = user_input.chomp.to_i
	 end
   end
   
   if vars["options"]["TEST_TYPE"] == "jmeter"
     # NUMBER_OF_ENGINES only available if JMeter test was selected in TEST_TYPE
    if !vars["options"]["NUMBER_OF_ENGINES"]
	  #todo: get the limits
      puts "Enter number of engines(Default- auto, [1-60]): "
	  user_input = gets.chomp
	  while user_input != "" && (user_input.to_i < 1 || user_input.to_i > 60)
	     if(user_input.to_i < 1 || user_input.to_i > 60)
		  puts "Value must be between 1-60"
		end
		 puts "Enter number of engines(Default- auto, [1-60]): "
	     user_input = gets.chomp
	  end
	  
	  if user_input != ""
	    vars["options"]["NUMBER_OF_ENGINES"] = user_input.to_i
	  end
     end
   else 
     #make sure this option isn't passed in case of other test_types
     vars["options"].delete("NUMBER_OF_ENGINES")
   end
   
   if vars["options"]["NUMBER_OF_ENGINES"]
     #[Auto] wasn't selected in NUMBER_OF_ENGINES
	 user_text = "Maximum number of concurrent users per load engine[20-36000]"
   else
     #[Auto] Was selected in NUMBER_OF_ENGINES 
	 user_text = "Maximum number of concurrent users[20-36000]"
   end
   
   if !vars["options"]["USERS"]     
	 #mandatory field
	 puts "Enter "+user_text+":"
     user_input = gets.chomp
	 while user_input.empty? || (user_input.to_i < 20 || user_input.to_i > 36000) do
	  if !user_input.empty? && (user_input.to_i < 20 || user_input.to_i > 36000)
	    puts "Incorrect value. "
	  end
	  puts "* mandatory field."
	  puts "Enter "+user_text+":*"
      user_input = gets.chomp
	 end 
	 vars["options"]["USERS"] = user_input
   end
   
   if vars["options"]["NUMBER_OF_ENGINES"] && vars["options"]["USERS"]
	 #[Auto] wasn't selected in NUMBER_OF_ENGINES
	 vars["options"]["OVERRIDE_THREADS"] = vars["options"]["USERS"]
	 vars["options"].delete("USERS")
   end
   
     if vars["test_name"]
	   test_name = vars["test_name"]
	 end
	 
	 options["options"] = vars["options"]

	 blaze = BlazemeterApi.new(user_key)
	 test_id = blaze.testCreate(test_name, options)
	 if test_id
	   #Upload JMX script
	   filename = File.basename(vars["jmx_filepath"])
	   blaze.testScriptUpload(test_id, vars["jmx_filepath"], filename)
	 end
    rescue "help"
      return help
    end
  end
  
  def cmd_start argv
	begin
     user_key = Blazemeter::Common.get_user_key
	 if !user_key
	   puts "You must enter API Key. Use blazemeter api:init"
	   return
	 end
	 vars = Blazemeter::Command::Test.parse argv
	 if !vars["test_id"]
       puts "Enter test id: "
	   user_input = gets
	   vars["test_id"] = user_input.chomp
     end
	 
	 if vars["test_id"] == ''
	   puts "Test id is required"
	   exit
	 end
	 blaze = BlazemeterApi.new(user_key)
	 blaze.testStart(vars["test_id"])
    rescue "help"
      return help
    end
  end
  
  def cmd_stop argv
    begin
     user_key = Blazemeter::Common.get_user_key
	 if !user_key
	   puts "You must enter API Key. Use blazemeter api:init"
	   return
	 end
	 vars = Blazemeter::Command::Test.parse argv
	  if !vars["test_id"]
       puts "Enter test id: "
	   user_input = gets
	   vars["test_id"] = user_input.chomp
     end
	 
	 if vars["test_id"] == ''
	   puts "Test id is required"
	   exit
	 end
	 blaze = BlazemeterApi.new(user_key)
	 blaze.testStop(vars["test_id"])
    rescue "help"
      return help
    end
  end
  
  def cmd_update argv
    options = Hash.new
    options["options"] = Hash.new
	begin
     user_key = Blazemeter::Common.get_user_key
	 if !user_key
	   puts "You must enter API Key. Use blazemeter api:init"
	   return
	 end
	 blaze = BlazemeterApi.new(user_key)
	 vars = Blazemeter::Command::Test.parse argv

	 #todo: we need to check test type from existing test
	 test_type = "jmeter" #hardcoded until next version
	 
	 #todo: check if this can be on even if we don't override anything
	 vars["options"]["OVERRIDE"] = 1 #turn on overriding
	 
	if !vars["test_id"]
      puts "Enter test id: "
	  user_input = gets
	  if user_input.chomp != ""
	    test_id = user_input.chomp
	  else
       	puts "Test id is required"
	    exit 
	  end
	else
	  test_id = vars["test_id"]
    end
	
	old_vars = blaze.testGetStatus(test_id, true)
	
	if !vars["options"]["LOCATION"]
      puts "Enter location(Default - don't change, California, Oregon, Ireland, Sydney, Tokyo, Singapore, Sao Paulo): "
	  user_input = gets
	  if user_input.chomp != ""
	    vars["options"]["LOCATION"] = user_input.chomp
	  end
    end
	
	if !vars["jmx_filepath"]
       puts "Enter a path to a JMX file(don't change): "
	   user_input = gets.chomp
	   while !user_input.empty? && !File.exist?(user_input) do
		 puts "File doesn't exist. Please enter absolute path, or relative to the "+Dir.pwd
	     puts "Enter a path to a JMX file(don't change): "
         user_input = gets.chomp
	   end 
	   if !user_input.empty? 
	     vars["jmx_filepath"] = user_input
	   end
   end
   
   if !vars["options"]["JMETER_VERSION"]
     puts "Enter Jmeter version(Default - don't change, 2.9, 2.8, 2.7, 2.6, 2.5, 2.4, 2.3.2): "
	 user_input = gets
	 if user_input.chomp != ""
	   vars["options"]["JMETER_VERSION"] = user_input.chomp.to_f
	 end
   end
   
   if !vars["options"]["OVERRIDE_RAMP_UP"]
     puts "Enter ramp up(don't change): "
	 user_input = gets
	 if user_input.chomp != ""
	   vars["options"]["OVERRIDE_RAMP_UP"] = user_input.chomp.to_i
	 end
   end
   
   if !vars["options"]["OVERRIDE_ITERATIONS"]
     puts "Enter iterations(don't change): "
	 user_input = gets
	 if user_input.chomp != ""
	   vars["options"]["OVERRIDE_ITERATIONS"] = user_input.chomp.to_i
	 end
   end
   
   if !vars["options"]["OVERRIDE_DURATION"]
     puts "Enter duration(don't change): "
	 user_input = gets
	 if user_input.chomp != ""
	   vars["options"]["OVERRIDE_DURATION"] = user_input.chomp.to_i
	 end
   end
   
   if test_type == "jmeter"
     # NUMBER_OF_ENGINES only available if JMeter test was selected in TEST_TYPE
    if !vars["options"]["NUMBER_OF_ENGINES"]
      puts "Enter number of engines(Default- don't change, [1-60]): "
	  user_input = gets.chomp
	   while user_input != "" && (user_input.to_i < 1 || user_input.to_i > 60)
	     if(user_input.to_i < 1 || user_input.to_i > 60)
		  puts "Value must be between 1-60"
		end
		 puts "Enter number of engines(Default- auto, [1-60]): "
	     user_input = gets.chomp
	  end
	  if user_input != ""
	    vars["options"]["NUMBER_OF_ENGINES"] = user_input.to_i
	  end
     end
   else 
     #make sure this option isn't passed in case of other test_types
     vars["options"].delete("NUMBER_OF_ENGINES")
   end
   
   #todo: check number_of_engines value from original test
   
   if vars["options"]["NUMBER_OF_ENGINES"] || old_vars["options"]["NUMBER_OF_ENGINES"] != "0"
     #[Auto] wasn't selected in NUMBER_OF_ENGINES
	 user_text = "Maximum number of concurrent users per load engine(Default- don't change, [20-36000])"
   else
     #[Auto] Was selected in NUMBER_OF_ENGINES 
	 user_text = "Maximum number of concurrent users(Default- don't change, [20-36000])"
   end
   
   if !vars["options"]["USERS"]
     puts "Enter "+user_text+":"
	 user_input = gets.chomp
	 
	 while !user_input.empty? && (user_input.to_i < 20 || user_input.to_i > 36000) do
	   puts "Incorrect value. "
	   puts "Enter "+user_text+":"
       user_input = gets.chomp
	 end 
	 
	 if user_input != ""
	   vars["options"]["USERS"] = user_input
	 end 
   end
   
   if (vars["options"]["NUMBER_OF_ENGINES"] || old_vars["options"]["NUMBER_OF_ENGINES"] != "0")&& vars["options"]["USERS"]
	 #[Auto] wasn't selected in NUMBER_OF_ENGINES
	 vars["options"]["OVERRIDE_THREADS"] = vars["options"]["USERS"]
	 vars["options"].delete("USERS")
   end
   
   	 options["options"] = vars["options"]
	 
	 blaze.testUpdate(test_id, options)
	 if vars["jmx_filepath"]
	   filename = File.basename(vars["jmx_filepath"])
	   blaze.testScriptUpload(test_id, vars["jmx_filepath"], filename)
	 end
	 
    rescue "help"
      return help
    end
  end
  
  def cmd_status argv
    begin
     user_key = Blazemeter::Common.get_user_key
	 if !user_key
	   puts "You must enter API Key. Use blazemeter api:init"
	   return
	 end
	 vars = Blazemeter::Command::Test.parse argv
	 
	 if !vars["test_id"]
       puts "Enter test id: "
	   user_input = gets
	   vars["test_id"] = user_input.chomp
     end
	 
	 if vars["test_id"] == ''
	   puts "Test id is required"
	   exit
	 end
	
	 blaze = BlazemeterApi.new(user_key)
	 status = blaze.testGetStatus(vars["test_id"])
	 if !status["error"] and status["response_code"] == 200
      puts "BlazeMeter status: " + status["status"]
     else
      puts "Error retrieving status: " + status["error"]
     end
	 
    rescue "help"
      return help
    end
  end
  
  def cmd_options argv
    begin
     user_key = Blazemeter::Common.get_user_key
	 if !user_key
	   puts "You must enter API Key. Use blazemeter api:init"
	   return
	 end
	 vars = Blazemeter::Command::Test.parse argv
	 
	 if !vars["test_id"]
       puts "Enter test id: "
	   user_input = gets
	   vars["test_id"] = user_input.chomp
     end
	 
	 if vars["test_id"] == ''
	   puts "Test id is required"
	   exit
	 end
	
	 blaze = BlazemeterApi.new(user_key)
	 status = blaze.testGetStatus(vars["test_id"], true)
	 if !status["error"] and status["response_code"] == 200
      puts "BlazeMeter options: "
	  puts status
     else
      puts "Error retrieving status: " + status["error"]
     end
	 
    rescue "help"
      return help
    end
  end
  
  def cmd_query argv
    begin
     user_key = Blazemeter::Common.get_user_key
	 vars = Blazemeter::Command::Test.parse argv
	 
	 if !vars["test_id"]
      puts "Enter test id: "
	  user_input = gets
	  if user_input.chomp != ""
	    test_id = user_input.chomp
	  else
       	puts "Test id is required"
	    exit 
	  end
	else
	  test_id = vars["test_id"]
    end
	
	 blaze = BlazemeterApi.new(user_key)
	 blaze.testGetArchive(test_id)
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
		hash["options"] = Hash.new

        while not argv.empty?
            hash['steps'] << Hash.new
            step = hash['steps'].last

            while not argv.empty?
                break if argv.first[0,1] != '-'

                k = argv.shift
                if ['-u'].member? k
                    hash['options']['USERS'] = shift(k, argv)
                    next
                end
				if ['-n'].member? k
                    hash['test_name'] = shift(k, argv)
                    next
                end
				if ['-l'].member? k
                    hash['options']['LOCATION'] = shift(k, argv)
                    next
                end
				if ['-id'].member? k
                    hash['test_id'] = shift(k, argv)
                    next
                end
				if ['-j'].member? k
                    hash['options']['JMETER_VERSION'] = shift(k, argv).to_f
                    next
                end
				if ['-r'].member? k
                    hash['options']['OVERRIDE_RAMP_UP'] = shift(k, argv).to_i
                    next
                end
				if ['-i'].member? k
                    hash['options']['OVERRIDE_ITERATIONS'] = shift(k, argv).to_i
                    next
                end
				if ['-d'].member? k
                    hash['options']['OVERRIDE_DURATION'] = shift(k, argv).to_i
                    next
                end
				if ['-en'].member? k
                    hash['options']['NUMBER_OF_ENGINES'] = shift(k, argv).to_i
                    next
                end
				if ['-jmx'].member? k
                    hash['jmx_filepath'] = shift(k, argv).to_i
                    next
                end
				if ['-a'].member? k
                    hash['apikey'] = shift(k, argv).to_i
                    next
                end
				
				
				raise ArgumentError, "Unknown option #{k}"
			end	
		  break if hash['help']
		end
		if not hash['help']
            #if hash['steps'].empty?
             #   raise ArgumentError, "no options specified!"
            #end
        end

        hash
    end		
	
end
end # Command
end # Blazemeter