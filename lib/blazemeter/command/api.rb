class Blazemeter
class Command
class API < Command # :nodoc:
  attr_accessor :user_key

  def cmd_init argv
    @user_key = user_key
	if !@user_key
	  @user_key = read_credentials[0]
	  if !@user_key
	    @user_key = ask_for_credentials
	    write_credentials
	  end
	end
  end
  
  def cmd_login argv
    @user_key = ask_for_credentials
	write_credentials
  end

  def credentials_file
      Blazemeter::Common.credentials_file
  end
  
  def read_credentials
      Blazemeter::Common.read_credentials
  end
  
  def ask_for_credentials
        puts "Enter your BlazeMeter credentials. You can find this in TODO."
        print "API-Key: "
        apik = gets
        return apik.chomp.strip
  end
  
  
  
  def write_credentials
        FileUtils.mkdir_p(File.dirname(credentials_file))
        File.open(credentials_file, 'w') do |f|
          f.puts @user_key
        end
        set_credentials_permissions
    end
	
	def set_credentials_permissions
        FileUtils.chmod 0700, File.dirname(credentials_file)
        FileUtils.chmod 0600, credentials_file        
    end
	
end
Api = API
end # Command
end # Blazemeter