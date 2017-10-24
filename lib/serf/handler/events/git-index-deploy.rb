require 'serf/handler' unless Object.const_defined?(:Serf) && Serf.const_defined?(:Handler)
include Serf::Handler

describe "Expects a hash code in the payload which will be queried using",
         "git-index. A 'git fetch --all && git pull' will be executed on all",
         "matching repositories."

on :event, 'git-index-deploy' do |event|
  user = `whoami` # Serf's executable environments are stripped of even basic information like HOME
  dir = `eval echo "~#{user}"`.strip
  `git-index -d #{dir}/.git-index.db -q #{event.payload}`.split(/\n/).each do |match|
    hash,data = match.split(/:\s+/,2)
    path,url = data.split(/\|/,2)
    system("cd #{path} && git fetch --all && git pull")
  end
end
