require 'serf/handler' unless Object.const_defined?(:Serf) && Serf.const_defined?(:Handler)
include Serf::Handler

describe "Return a comma separated table of CPU performance information",
         "collected from mpstat."

on :query, 'mpstat' do |event|
  `/usr/bin/mpstat`.split(/\n/)[2..-1].collect {|r| r.split.join(',').sub(/,/,' ')}.join("\n")
end
