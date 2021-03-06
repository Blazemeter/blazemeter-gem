class Blazemeter
class Command
class API < Command # :nodoc:
  attr_accessor :user_key

  def cmd_init argv
    @user_key = user_key
	#ENV['BLAZEMETER_APIKEY'] = '123'
	#get apikey stored on this computer
	if !@user_key
	  @user_key = read_credentials[0]
	end
	
	if !@user_key
	  #First get apikey from cmd line
	  vars = Blazemeter::Command::Test.parse argv
	  @user_key = vars["apikey"]
	  
	  #Secondly get apikey from heroku
	  if !@user_key && ENV['BLAZEMETER_APIKEY']
		puts "Heroku BlazeMeter APIKEY found. Use it? [y/n]"
		use = gets.chomp.downcase
		if use[0..0] == 'y'
		  @user_key = ENV['BLAZEMETER_APIKEY']
		end
	  end
	  #Thirdly get apikey by prompting user
	  if !@user_key
	    @user_key = ask_for_credentials
	  end
	  
	  if @user_key
	    write_credentials
	    puts "Blazemeter API KEY stored."
	  end
	  else
      puts "BlazeMeter already initialized. Use blazemeter api:reset to change API KEY"	  
	end
  end
  
  def cmd_reset argv
	@user_key = nil
	write_credentials
	puts "BlazeMeter is reset."
  end
  
  def cmd_validoptions argv
	user_key = Blazemeter::Common.get_user_key
	if !user_key
	   puts "You must enter API Key. Use blazemeter api:init"
	   return
	 end
	blaze = BlazemeterApi.new(user_key)
	puts "Valid options for your account: "
    puts blaze.getOptions()	
  end

  def credentials_file
      Blazemeter::Common.credentials_file
  end
  
  def read_credentials
      Blazemeter::Common.read_credentials
  end
  
  def ask_for_credentials
        puts "Enter your BlazeMeter credentials. You can find this in https://a.blazemeter.com/user"
        print "API-Key: "
        apik = gets
        return apik.chomp.strip
  end
  
  def write_credentials
       Blazemeter::Common.write_credentials(@user_key)
  end
end
Api = API
end # Command
end # Blazemeter