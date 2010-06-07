require "unit/helpers/model_no_ar"
require "icalfetch"
require "yaml_config"

class IcalfetchTest < Test::Unit::TestCase
  def setup
    @ical = Icalfetch.new
  end

  def base_event
    event = Event.new
    event.start = DateTime.civil(2006, 6, 23, 8, 30)
    event.summary = "A great event!"
    return event
  end

  def test_add_reminder
    event = base_event()
    @ical.add_reminder event, 18
    assert_equal 1, event.alarms.length
    alarm = event.alarms[0]
    assert_equal "-PT18M", alarm.trigger
    assert_equal "This is an event reminder", alarm.description    
  end

  def test_add_reminder_already_there
    event = base_event()
    alarm = event.alarm
    alarm.trigger = "existingTriggerHere"
    alarm.description = "This is an event reminder"
    @ical.add_reminder event, 18
    assert_equal 1, event.alarms.length
    alarm = event.alarms[0]
    assert_equal "existingTriggerHere", alarm.trigger
  end

  def test_process_ical_string
    event1 = base_event()
    event2 = base_event()
    cal = Calendar.new
    cal.add_event(event1)
    cal.add_event(event2)
    result = @ical.process_ical_string cal.to_ical, 22
    cals = Icalendar.parse result
    newCal = cals[0]
    event = newCal.events[0]
    assert_equal event1.uid, event.uid
    assert_equal 1, event.alarms.length
    alarm = event.alarms[0]
    assert_equal "-PT22M", alarm.trigger
    assert_equal "This is an event reminder", alarm.description
    event = newCal.events[1]
    assert_equal event2.uid, event.uid
    assert_equal 1, event.alarms.length
    alarm = event.alarms[0]
    assert_equal "-PT22M", alarm.trigger
    assert_equal "This is an event reminder", alarm.description
  end

  def test_process_ical_feed
    basepath = File.expand_path(File.dirname(__FILE__))+"/../../config"
    props = BW::YAMLConfig.new("#{basepath}/config_default.yml",
                               "#{basepath}/config.yml").props
    uid = props['icalfetch_test']['uid']
    key = props['icalfetch_test']['key']
    result = @ical.process_ical_feed uid,
                                     key,
                                     15

    assert_not_nil result
  end

  def test_generate_query_string
      result = @ical.generate_query_string "hi",
                                     "there"
      assert_equal "uid=hi&key=there", result
  end 
end