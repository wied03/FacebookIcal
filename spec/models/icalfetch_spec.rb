#require File.dirname(__FILE__) + '/../spec_helper'
require "spec"
require "yaml_config"
require "icalfetch"
require "test_logger"

def base_event
  event = Event.new
  event.start = DateTime.civil(2006, 6, 23, 8, 30)
  event.summary = "A great event!"
  return event
end

describe "Ical Fetch" do
  before(:each) do
    @ical = Icalfetch.new
  end

  it "Adds a reminder OK" do
    event = base_event()
    @ical.add_reminder event, 18
    event.alarms.length.should == 1
    alarm = event.alarms[0]
    alarm.trigger.should == "-PT18M"
    alarm.description.should == "This is an event reminder"
  end

  it "Doesn't add a reminder if one already exists" do
    event = base_event()
    alarm = event.alarm
    alarm.trigger = "existingTriggerHere"
    alarm.description = "This is an event reminder"
    @ical.add_reminder event, 18

    event.alarms.length.should == 1
    alarm = event.alarms[0]
    alarm.trigger.should == "existingTriggerHere"
  end

  it "Process the iCal string end to end" do
    event1 = base_event()
    event2 = base_event()
    cal = Calendar.new
    cal.add_event(event1)
    cal.add_event(event2)
    result = @ical.process_ical_string cal.to_ical, 22

    cals = Icalendar.parse result
    newCal = cals[0]
    event = newCal.events[0]
    event.uid.should == event1.uid
    event.alarms.length.should == 1

    alarm = event.alarms[0]
    alarm.trigger.should == "-PT22M"
    alarm.description.should == "This is an event reminder"

    event = newCal.events[1]
    event.uid.should == event2.uid
    event.alarms.length.should == 1

    alarm = event.alarms[0]
    alarm.trigger.should == "-PT22M"
    alarm.description.should == "This is an event reminder"
  end

  it "Generates the query string OK" do
      result = @ical.generate_query_string "hi",
                                           "there"
      result.should =="uid=hi&key=there"
  end

  it "Process a real iCal feed from Facebook OK" do
    basepath = File.expand_path(File.dirname(__FILE__))+"/../config"
    props = BW::YAMLConfig.new("#{basepath}/config_default.yml",
                               "#{basepath}/config.yml").props
    uid = props['icalfetch_test']['uid']
    key = props['icalfetch_test']['key']
    result = @ical.process_ical_feed uid,
                                     key,
                                     15

    result.should_not == nil
  end
end