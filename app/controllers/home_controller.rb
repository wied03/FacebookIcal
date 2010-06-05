class HomeController < ApplicationController
  def view
    @ical = Icalfetch.new
    result = @ical.process_ical_feed CGI::escape(params[:uid]),
                                     CGI::escape(params[:key]),
                                     params[:minutes]
    send_data result,
              :type => "text/calendar",
              :filename => "#{params[:uid]}.ics",
              :disposition => "attachment"
  end

end
