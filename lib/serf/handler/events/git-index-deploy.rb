require 'serf/handler' unless Object.const_defined?(:Serf) && Serf.const_defined?(:Handler)
include Serf::Handler

describe "Expects a hash code in the payload which will be queried using",
         "git-index. A 'git fetch --all && git pull' will be executed on all",
         "matching repositories. Deployment hooks are available in order to",
         "execute arbitrary code during the deploy process. If any of the",
         "following files are found in the REPO root directory, they will be",
         "executed in the order described by their name.\n",
         ".serf-before-deploy\n",
         ".serf-after-deploy\n",
         ".serf-on-deploy-failure\n",
         ".serf-on-deploy-success\n"

on :event, 'git-index-deploy' do |event|
  user = `whoami` # Serf's executable environments are stripped of even basic information like HOME
  dir = `eval echo "~#{user}"`.strip
  `git-index -d #{dir}/.git-index.db -q #{event.payload}`.split(/\n/).each do |match|
    hash,data = match.split(/:\s+/,2)
    path,url = data.split(/\|/,2)

    ENV['SERF_DEPLOY_PAYLOAD'] = event.payload
    ENV['SERF_DEPLOY_HASH'] = hash
    ENV['SERF_DEPLOY_PATH'] = path
    ENV['SERF_DEPLOY_URL'] = url

    success = Dir.chdir(path)
    break unless success

    if FileTest.exist?(File.join(path, ".serf-before-deploy"))
      system(File.join(path, ".serf-before-deploy"))
    end

    success = system("git fetch --all && git pull")

    if success && FileTest.exist?(File.join(path, ".serf-on-deploy-success"))
      system(File.join(path, ".serf-on-deploy-success"))
    elsif !success && FileTest.exist?(File.join(path, ".serf-on-deploy-failure"))
      system(File.join(path, ".serf-on-deploy-failure"))
    end

    if FileTest.exist?(File.join(path, ".serf-after-deploy"))
      system(File.join(path, ".serf-after-deploy"))
    end
  end
end
