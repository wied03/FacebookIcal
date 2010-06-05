require 'icalendar'
require 'date'
require 'net/http'
require 'uri'

include Icalendar

# Extending iCalendar's Event class with additional properties
class Event
  # A property present in Facebook iCAL feeds
  ical_property :partstat 
end

class Icalfetch < BaseModel
  def initialize
    @@logger = createlogger "Icalfetch"
  end

  # Adds an alarm using reminderTimeInMinutes to the supplied event.  If an existing display reminder# is already there, this won't do anything

  def add_reminder event,
                   reminderTimeInMinutes

    event.alarms.each do |a|
      return if a.action == "DISPLAY"
    end

    # Create a new alarm
    alarm = event.alarm
    alarm.trigger = "-PT#{reminderTimeInMinutes}M"
    alarm.description = "This is an event reminder"
  end

  # Processes an iCal string and returns a string with the same events, but with reminders added
  def process_ical_string(data, reminderMinutes)
    cals = Icalendar.parse(data)
      cals.each do |cal|
        cal.events.each do |e|
          add_reminder e, reminderMinutes
        end
        @@logger.info "Processed #{cal.events.length} events"
    end
    return cals.to_ical
  end

  # Processes/Parses an iCal HTTP feed address and returns a string with the same events, but with
  # reminders added
  def process_ical_feed uid,
                        key,
                        reminderMinutes
    queryString = generate_query_string uid,
                                        key
    host = "www.facebook.com"
    if @@logger.debug?
      @@logger.debug "Connecting to Facebook using host: #{host}"
    end
    httpReq = Net::HTTP.new host
    path = "/ical/u.php?#{queryString}"
    if @@logger.debug?
      @@logger.debug "Facebook path: #{path}"
    end
    resp,data = httpReq.get path
    return process_ical_string(data, reminderMinutes)
  end

  def generate_query_string uid,
                            key

    query_string = {:uid => uid,
                    :key => key}
    
    unless query_string.empty?
      query_params = query_string.collect {|k,v| "#{k}=#{v}"}
      query_params.join("&")
    end
  end
end