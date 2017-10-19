require 'serf/handler' unless Object.const_defined?(:Serf) && Serf.const_defined?(:Handler)
include Serf::Handler

describe "Takes the name of a handler and returns its description. If there are",
         "multiple handlers with the same name, all matching results will be",
         "returned."

on :query, 'describe-handler' do |event|
  name = event.payload.strip
  Serf::Handler::Tasks.select do |task|
    name == task.name
  end.collect do |task|
    task.description
  end.join("\n---\n")
end
