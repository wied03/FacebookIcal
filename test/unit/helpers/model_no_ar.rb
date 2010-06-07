$: << File.expand_path(File.dirname(__FILE__) +"/../../../app/models")
require "test/unit"
require "base_model"
require 'log4r'

class BaseModel
  def createlogger className
    Log4r::Logger.root.level = Log4r::DEBUG
    formatter = Log4r::PatternFormatter.new(:pattern => "[%5l] %d %30C - %m")
    Log4r::StderrOutputter.new('console', :formatter => formatter)
    Log4r::Logger.new('App').add('console')
    Log4r::Logger.new "App::#{className}"
  end 
end
