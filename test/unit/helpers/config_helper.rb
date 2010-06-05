class ConfigHelper
  attr_accessor :props
  private_class_method :new

  @@config = nil
  def ConfigHelper.it
    @@config = new unless @@config
    @@config
  end

  def initialize
      default_props = YAML::load(File.read('config/config_default.yml'))
      prop = 'config/config.yml'
      FileUtils.touch prop unless File.exists? prop
      user_props = YAML::load(File.read(prop))
      @props = merge user_props, default_props
  end

  private
  
  def merge(user, default)
	return default if default.class != Hash or user.class != Hash
	default.each do |key, value|
		if !user.has_key? key
			user[key] = value
		else
			user[key] = merge(user[key], value)
		end
	end
	user
  end
end