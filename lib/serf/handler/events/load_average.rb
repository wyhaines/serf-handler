require 'serf/handler' unless Object.const_defined?(:Serf) && Serf.const_defined?(:Handler)
include Serf::Handler

describe "Return the 1-minute, 5-minute, and 15-minute load averages as a",
         "comma separated list of values."

on :query, 'load-average' do |event|
  `/usr/bin/uptime`.gsub(/^.*load\s+averages:\s+/,'').split.join(',').strip
end
