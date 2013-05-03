class Blazemeter
class Command
class Help < Command # :nodoc:
    def cmd_default argv
        
        msg = "Usage: blazemeter <command> <options>"
		puts msg
        helps = [
            { :cmd => 'help', :help => "Display this help" },
            { :cmd => 'api:init', :help => 'Store your API key' },
			{ :cmd => 'api:login', :help => 'Reenter your API key' },
            { :cmd => 'blazemeter:create', :help => 'generate blazemeter test' },
            { :cmd => 'blazemeter:start', :help => 'starts blazemeter test' },
			{ :cmd => 'blazemeter:stop', :help => 'stops blazemeter test' },
			{ :cmd => 'blazemeter:update', :help => 'updates blazemeter test' },
			{ :cmd => 'blazemeter:status', :help => 'show blazemeter test status' }
        ]
        
        max_cmd_size = helps.inject(0) { |memo, obj| [ obj[:cmd].size, memo ].max } + 4
        helps.each do |h|
            msg "%*s - %s" % [max_cmd_size, h[:cmd], h[:help]]
        end
        puts
    end
end
end # Command
end # Blitz
