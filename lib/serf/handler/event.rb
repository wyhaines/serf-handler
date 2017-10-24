module Serf
  module Handler
    class Event
      attr_accessor :type, :name, :payload

      def initialize(cli = {})
        @type = cli[:type] || ENV['SERF_EVENT']&.to_sym || :query
        @type = :event if @type == :user
        @name = cli[:name] || ( @type == :query ? ENV['SERF_QUERY_NAME'] : ENV['SERF_USER_EVENT'] )
        @payload = cli[:payload] || STDIN.read
        @payload.strip!
      end
    end
  end
end
