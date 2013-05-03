require "rubygems"
require "json"
require "net/https"
require "uri"
require "fileutils"
require 'blazemeter/command'
require 'blazemeter/utils'
require 'blazemeter/common'

class Blazemeter # :nodoc:    
    def self.run cmd, argv
	
		kname, mname = cmd.split(':', 2)
        klass = Blazemeter::Command.const_get kname.capitalize rescue nil
		mname ||= 'default'
        mname = "cmd_#{mname}".to_sym
		if klass and klass < Blazemeter::Command and klass.method_defined? mname
            command = klass.new
            begin
                command.send mname, argv
            rescue Test::Unit::AssertionFailedError, ArgumentError => e
                $stderr.puts "!! #{e.message.chomp('.')}" 
            end
        else
            puts "Unknown command #{cmd}"
        end        
    end    
end

class BlazemeterApi
  @@url = 'https://a.blazemeter.com'
  #@@url = 'http://dev1.zoubi.me'
  
  def initialize(user_key)
    @user_key = user_key
  end
  
  def get_https(uri)
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
	return https
  end
  
  def post(path, options=nil)
    uri = URI.parse(@@url+path)
	options = options.to_json
    https = get_https(uri)
    req = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
	req.body = options
	response = https.request(req)
	return response
  end
  
  def get(path)
    uri = URI.parse(@@url+path)
    https = get_https(uri)
    req = Net::HTTP::Get.new(uri.request_uri)
	response = https.request(req)
	return response
  end
  
  def testCreate(test_name=nil, max_users=nil, location=nil)
   options = Hash.new
   options["options"] = Hash.new
   
   if !test_name
     puts "Enter name for the test: "
	 user_input = gets
	 test_name = user_input.chomp
   end
   
   if !max_users
     puts "Enter MAX_USERS: "
	 user_input = gets
	 max_users = user_input.chomp
   end
   
   if !location
     puts "Enter LOCATION: "
	 user_input = gets
	 location = user_input.chomp
   end
   
   if max_users != ''
     options["options"]["MAX_USERS"] = max_users
   end
   
   if location != ''
     options["options"]["LOCATION"] = location
   end
   
   path = '/api/rest/blazemeter/testCreate.json?user_key=' + @user_key + '&test_name=' + URI.escape(test_name) 
   response = post(path, options)
   
   if response.body == ''
     puts "BlazeMeter server not responding"
	 return nil
   end
   
   ret = JSON.parse(response.body)

   if ret["error"]
     puts "BlazeMeter returned error: "+ret["error"]
   else
     if ret["response_code"] == 200
	  puts "BlazeMeter test created with id "+ret["test_id"].to_s
	  puts "Access test online at "+@@url+"/node/"+ret["test_id"].to_s
      return ret["test_id"]
	 else 
     puts "BlazeMeter server response error:"+ret["response_code"].to_s
	 end
   end   
   
  end
  
  def testStart(test_id=nil)
	if !test_id
     puts "Enter test id: "
	 user_input = gets
	 test_id = user_input.chomp
    end
	path = '/api/rest/blazemeter/testStart.json?user_key=' + @user_key + '&test_id=' + test_id.to_s 
    response = get(path)
    ret = JSON.parse(response.body)
	if !ret["error"] and ret["response_code"] == 200
	 puts "BlazeMeter test started"
     return true
    else
	 #todo: what to do with error? log? throw exception?
	  puts "Test not started. Error: "+ret["error"]
     return false
   end   
  end
  
  def testStop(test_id=nil)
    if !test_id
     puts "Enter test id: "
	 user_input = gets
	 test_id = user_input.chomp
    end
    path = '/api/rest/blazemeter/testStop.json?user_key=' + @user_key + '&test_id=' + test_id.to_s 
	response = get(path)
    puts "Response #{response.code} #{response.message}:
          #{response.body}"
		  
    ret = JSON.parse(response.body)
	if !ret["error"] and ret["response_code"] == 200
	 puts "BlazeMeter test stopped"
     return true
    else
	 #todo: what to do with error? log? throw exception?
	 puts "Test not stopped. Error: "+ret["error"]
     return false
   end   
  end
  
  def testUpdate(test_id=nil, max_users=nil, location=nil)
    if !test_id
     puts "Enter test id: "
	 user_input = gets
	 test_id = user_input.chomp
    end
	
	if !max_users
     puts "Enter MAX_USERS: "
	 user_input = gets
	 max_users = user_input.chomp
   end
   
   if !location
     puts "Enter LOCATION: "
	 user_input = gets
	 location = user_input.chomp
   end
	
    path = '/api/rest/blazemeter/testUpdate.json?user_key=' + @user_key + '&test_id=' + test_id.to_s 
	options = Hash.new
    options["options"] = Hash.new
	
   if max_users != ''
     options["options"]["MAX_USERS"] = max_users
   end
   
   if location != ''
     options["options"]["LOCATION"] = location
   end
   
   if (options)
	options = options.to_json
   end	
	
   response = post(path, options)
   
   if response.body == ''
     puts "BlazeMeter server not responding"
	 return nil
   end
   
   ret = JSON.parse(response.body)
   
	if ret["error"]
     puts "BlazeMeter returned error: "+ret["error"]
   else
     if ret["response_code"] == 200
	  puts "BlazeMeter test updated sucessfully"
      return true
	 else 
       puts "BlazeMeter test not updated. Error:"+ret["error"].to_s
	 end
   end
   return false
   
  end
  
  def testGetStatus(test_id=nil)
   if !test_id
     puts "Enter test id: "
	 user_input = gets
	 test_id = user_input.chomp
    end
    path = '/api/rest/blazemeter/testGetStatus.json?user_key=' + @user_key + '&test_id=' + test_id.to_s 
	response = get(path)
    ret = JSON.parse(response.body)
	if !ret["error"] and ret["response_code"] == 200
      puts "BlazeMeter status: " + ret["status"]
    else
     puts "Error retrieving status: " + ret["error"]
    end   
  end
  
end

