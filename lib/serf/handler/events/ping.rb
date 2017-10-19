require 'serf/handler' unless Object.const_defined?(:Serf) && Serf.const_defined?(:Handler)
include Serf::Handler

describe "Return a hearbeat from the system with the amount of time that it",
         "has been up."

on :query, 'ping' do |event|
  `/usr/bin/uptime`.sub(/^.*(up[^,]+).*\n?$/,'\1')
end
