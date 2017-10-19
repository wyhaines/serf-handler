require 'serf/handler' unless Object.const_defined?(:Serf) && Serf.const_defined?(:Handler)
include Serf::Handler

describe "Return a comma separated table of filesystem information."

on :query, 'df' do |event|
  `/bin/df -k`.split(/\n/).collect {|r| r.split.join(',').sub(/Mounted,on/,"Mounted on")}.join("\n")
end
