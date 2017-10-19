module Serf
  module Handler
    class Event
      attr_accessor :type, :name, :payload

      def initialize(cli = {})
        @type = cli[:type] || ENV['SERF_EVENT'].to_sym || :query
        @name = cli[:name] || ENV['SERF_QUERY_NAME']
        @payload = cli[:payload] || STDIN.read
      end
    end
  end
end
