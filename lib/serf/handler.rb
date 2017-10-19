require "serf/handler/version"
require "serf/handler/cli"
require "serf/handler/tasklist"
require "serf/handler/event"
require "json"

module Serf
  module Handler

    Tasks = TaskList.new

    def describe(*strings)
      description = ''
      strings.each do |line|
        if description[-1] =~ /[^\s]/ && line[0] =~ /[^\s]/
          description << " #{line}"
        else
          description << line
        end
      end

      @_handler_description = description
    end

    def on(*args, &block)
      if Hash === args.first
        type = args[:type]
        name = args[:name]
        order = args[:order]
      else
        type, name, order = *args
      end

      type ||= :query
      name ||= nil
      order ||= 0

      desc = @_handler_description
      @_handler_description = ''
      Tasks << Task.new(type, name, order, desc, &block)
    end

    class << self

      def run
        load_tasks
        result = run_tasks
        STDOUT.write ( result.length > 1 ? result.to_json : result.first )
      end

      def event
        unless @event
          config = Serf::Handler::Cli.new
          @event = Serf::Handler::Event.new( config )
        end

        @event
      end

      def load_tasks
        sources = []
        sources << ENV['SERF_HANDLER_CONFIG'] if ENV['SERF_HANDLER_CONFIG']
        sources << File.join(Dir.pwd,'.serf-handler','config.rb')
        sources << File.join( ENV['HOME'], '.serf-handler', 'config.rb' )
        source = sources.select {|s| FileTest.exist?( s )}.first
        require File.expand_path( source ) if source
      end

      def run_tasks
        result = []
        Tasks.sort.each do |task|
          next if task.type && task.type != event.type
          begin
            if task.type == :event && ( task.name.to_s.empty? || task.name.to_s == event.name.to_s )
              task.call event
            elsif task.type == :query && ( task.name.to_s.empty? || task.name.to_s == event.name.to_s )
              result << task.call( event )
            end
          rescue Exception => e
            result << "ERROR: #{e}"
          end
        end

        result
      end

    end
  end
end

require 'serf/handler/events/list-handlers'
require 'serf/handler/events/describe-handler'
