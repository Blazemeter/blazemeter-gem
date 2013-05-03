class Blazemeter
class Common # :nodoc:	
	def self.read_credentials
        File.exists?(credentials_file) and File.read(credentials_file).split("\n")        
    end
    def self.credentials_file
        ENV['HOME'] + '/.blazemeter/credentials'
    end
	def self.get_user_key
      read_credentials[0]
    end
end
end # Blazemeter