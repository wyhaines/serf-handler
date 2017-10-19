require 'optparse'

module Serf
  module Handler
    class Cli < Hash
      def initialize
        OptionParser.new do |opts|
          opts.banner = "Usage: handler [options]\n\nWhen given CLI options, payload items that are normally passed to the handler via Serf can be specified manually."
          opts.separator ''
          opts.on('-t','--type [TYPE]',[:query, :user],'The type of request to trigger -- a query or an event. Defaults to an event.') do |type|
            self[:type] = type
          end
          opts.on('-n','--name [NAME]',String,'The name of the query or event to trigger.') do |name|
            self[:name] = name
          end
          opts.on('-p','--payload [PAYLOAD]',String,'The payload to deliver to the event handler that processes the request.') do |payload|
            self[:payload] = payload.to_s
          end
        end.parse!
      end
    end
  end
end
