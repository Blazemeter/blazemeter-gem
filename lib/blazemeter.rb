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
  
  def getFile(url, filepath)
    uri = URI.parse(url)
    https = get_https(uri)
    resp = https.get(uri.request_uri)
	
    open(filepath, "wb") do |file|
        file.write(resp.body)
	end
  end
  
  def testCreate(test_name=nil, options=nil)
   if !test_name
     test_name = "Automatic Ruby Test "+Time.new.inspect
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
  
  def testStart(test_id)
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
  
  def testStop(test_id)
    path = '/api/rest/blazemeter/testStop.json?user_key=' + @user_key + '&test_id=' + test_id.to_s 
	response = get(path)
   
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
  
  def testUpdate(test_id, options=nil)
    path = '/api/rest/blazemeter/testUpdate.json?user_key=' + @user_key + '&test_id=' + test_id.to_s 
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
  
  def testGetStatus(test_id)
    path = '/api/rest/blazemeter/testGetStatus.json?user_key=' + @user_key + '&test_id=' + test_id.to_s 
	response = get(path)
    ret = JSON.parse(response.body)
	if !ret["error"] and ret["response_code"] == 200
      puts "BlazeMeter status: " + ret["status"]
    else
     puts "Error retrieving status: " + ret["error"]
    end   
  end
  
  def testLoad(test_id)
    path = '/api/rest/blazemeter/testUpdate.json?user_key=' + @user_key + '&test_id=' + test_id.to_s 
	response = post(path)
    ret = JSON.parse(response.body)
	if !ret["error"] and ret["response_code"] == 200
      return ret["options"]
    else
     puts "Error loading test: " + ret["error"]
	 return nil
    end   
  end
  
   def testGetArchive(test_id)
    path = '/api/rest/blazemeter/testGetArchive.json?user_key=' + @user_key + '&test_id=' + test_id.to_s 
	has_report = false
	response = get(path)
    ret = JSON.parse(response.body)
	if !ret["error"] and ret["response_code"] == 200
      ret["reports"].each_with_index {|val, index| 
		if ret["reports"][index]["zip_url"]
		  zip_url = ret["reports"][index]["zip_url"]
		  filename = File.basename zip_url
		  filepath = Dir.home+"/"+ filename
		  getFile(zip_url,filepath)
		  #todo: check that its downloaded
		  puts "Zip report downloaded to "+filepath
		  has_report = true
		end
	  }
	   if !has_report
	     puts "No reports found for test "+test_id
	   end
    else
     puts "Error retrieving archive: " + ret["error"]
    end   
  end
  
end

