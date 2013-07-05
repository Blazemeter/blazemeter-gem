class Blazemeter
class Common # :nodoc:	
	def self.read_credentials
	  if(!File.exists?(credentials_file))
	    write_credentials(nil)
	  end
        File.exists?(credentials_file) and File.read(credentials_file).split("\n")        
    end
    def self.credentials_file
        ENV['HOME'] + '/.blazemeter/credentials'
    end
	def self.init_credentials
     FileUtils.mkdir_p(File.dirname(credentials_file))
     set_credentials_permissions
    end
	def self.write_credentials(user_key)
        FileUtils.mkdir_p(File.dirname(credentials_file))
        File.open(credentials_file, 'w') do |f|
          f.puts user_key
        end
        set_credentials_permissions
    end
	
	def self.set_credentials_permissions
        FileUtils.chmod 0700, File.dirname(credentials_file)
        FileUtils.chmod 0600, credentials_file        
    end
	def self.get_user_key
      read_credentials[0]
    end
	
	def self.locations_hash
	  locations = Hash.new
      locations['ireland'] = 'eu-west-1'
	  locations['virginia'] = 'us-east-1'
	  locations['california'] = 'us-west-1'
	  locations['oregon'] = 'us-west-2'
	  locations['sao paulo'] = 'sa-east-1'
	  locations['singapore'] = 'ap-southeast-1'
	  locations['sydney'] = 'ap-southeast-2'
	  locations['tokyo'] = 'ap-northeast-1'
	  return locations
	end
	def self.get_location(location)
	  locations = locations_hash
	  if locations[location]
	    return locations[location]
	  else
        return location
      end	  
	  
	end
end
end # Blazemeter