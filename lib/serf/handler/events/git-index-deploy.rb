require 'serf/handler' unless Object.const_defined?(:Serf) && Serf.const_defined?(:Handler)
include Serf::Handler

describe "Expects a hash code in the payload which will be queried using",
         "git-index. A 'git fetch --all && git pull' will be executed on all",
         "matching repositories."

on :event, 'git-index-deploy' do |event|
  `git-index -q #{event.payload}`.split(/\n/).each do |match|
    hash,path = match.split(/:\s+/)
    system("cd #{path} && git fetch --all && git pull")
  end
end
