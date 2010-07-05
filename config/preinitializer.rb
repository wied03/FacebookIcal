require 'rake'

if !Rake::application().top_level_tasks.include?("gems:install")
  require 'log4r'
  # Brady's logging code
  Log4r::Logger.root.level = Log4r::DEBUG
  formatter = Log4r::PatternFormatter.new(:pattern => "[%5l] %d %30C - %m")
  Log4r::StderrOutputter.new 'console',
                             :formatter => formatter
  Log4r::Logger.new('App').add('console')
  RAILS_DEFAULT_LOGGER = Log4r::Logger.new('App::Rails')
  puts "Initialized log4r as the Rails default logger..."
else
  puts "Skipping log4r initilization since it might not be installed yet..."
end