require 'serf/handler' unless Object.const_defined?(:Serf) && Serf.const_defined?(:Handler)
include Serf::Handler

describe "If monit is running on the system, extract all current",
  "status information and return it as CSV data."

on :query, 'monit-status' do |event|
  data = `monit status`
  chunks = data.scan(/((?:System|Process).*?)\n\n/m)

  output = "\"field\",\"data\"\n" +
    chunks.collect do |chunk|
    chunk
      .first
      .split("\n")
      .collect do |line|
        Array
          .new(2)
          .zip(line.strip.split(/\s{2,}/,2))
          .collect do |pair|
            "\"#{pair.sort_by {|item| item.to_s}.last.to_s}\""
        end.join(',')
     end.join("\n")
  end.join("\n\" \",\" \"\n")
end
