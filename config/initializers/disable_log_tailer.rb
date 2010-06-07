# Disable the log tailer since we're using log4r and it outputs to the console
# with our configuration
module Rails
  module Rack
    class LogTailer
      def initialize(app, log = nil)
        @app = app
      end
      def tail_log
      end
    end
  end
end