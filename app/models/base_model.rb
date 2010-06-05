class BaseModel
  def createlogger className
    Log4r::Logger.new "App::#{className}"
  end
end
