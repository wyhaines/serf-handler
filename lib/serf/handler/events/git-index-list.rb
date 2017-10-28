require 'serf/handler' unless Object.const_defined?(:Serf) && Serf.const_defined?(:Handler)
include Serf::Handler

describe "Returns a list of all repositories that git-index knows of, if",
         "git-index is available to execute."

on :query, 'git-index-list' do |event|
  user = `whoami` # Serf's executable environments are stripped of even basic information like HOME
  dir = `eval echo "~#{user}"`.strip
  `git-index -d #{dir}/.git-index.db --list`
end
