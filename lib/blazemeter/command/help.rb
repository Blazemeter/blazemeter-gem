class Blazemeter
class Command
class Help < Command # :nodoc:
    def cmd_default argv
        
        puts "Usage: blazemeter <command> <options>"
        helps = [
            { :cmd => 'help', :help => 'Display this help' },
			{ :cmd => 'help:locations', :help => 'Display list of available test geo locations' },
            { :cmd => 'api:init', :help => 'Store your API key' },
			{ :cmd => 'api:reset', :help => 'Remove your API key' },
			{ :cmd => 'api:validoptions', :help => 'Returns a list of available options that can be used for test creation or modification.' },
            { :cmd => 'test:create', :help => 'generate blazemeter test' },
            { :cmd => 'test:start', :help => 'starts blazemeter test' },
			{ :cmd => 'test:stop', :help => 'stops blazemeter test' },
			{ :cmd => 'test:update', :help => 'updates blazemeter test' },
			{ :cmd => 'test:status', :help => 'show blazemeter test status' },
			{ :cmd => 'test:options', :help => 'show blazemeter test options' },
			{ :cmd => 'test:query', :help => 'returns the report (a zip file)' }
        ]
        
        max_cmd_size = helps.inject(0) { |memo, obj| [ obj[:cmd].size, memo ].max } + 4
        helps.each do |h|
            puts "%*s - %s" % [max_cmd_size, h[:cmd], h[:help]]
        end
        puts
    end
	def cmd_locations argv
	  helps = [
            { :cmd => 'eu-west-1', :help => 'EU West (Ireland)' },
			{ :cmd => 'us-east-1', :help => 'US East (Virginia)' },
            { :cmd => 'us-west-1', :help => 'US West (N.California)' },
			{ :cmd => 'us-west-2', :help => 'US West (Oregon)' },
            { :cmd => 'sa-east-1', :help => 'South America(Sao Paulo)' },
            { :cmd => 'ap-southeast-1', :help => 'Asia Pacific (Singapore)' },
			{ :cmd => 'ap-southeast-2', :help => 'Australia (Sydney)' },
			{ :cmd => 'ap-northeast-1', :help => 'Japan (Tokyo)' }
        ]
        
        max_cmd_size = helps.inject(0) { |memo, obj| [ obj[:cmd].size, memo ].max } + 4
        helps.each do |h|
            puts "%*s - %s" % [max_cmd_size, h[:cmd], h[:help]]
        end
        puts
	end
end
end # Command
end # Blitz
