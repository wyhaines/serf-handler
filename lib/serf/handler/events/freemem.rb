require 'serf/handler' unless Object.const_defined?(:Serf) && Serf.const_defined?(:Handler)
include Serf::Handler

describe "Return current memory and swap status as a csv"

on :query, 'freemem' do |event|
  data = `free -ht`
  lines = data.split("\n").collect {|line| line.split(/\s+/)}
  maxlength = lines.collect {|l| l.length}.max
  output = lines.collect do |line|
    Array
      .new(maxlength)
      .zip(line)
      .collect do |pair|
        pair.sort_by {|item| item.to_s}
          .last
          .to_s
      end
      .collect {|item| "\"#{item}\""}
      .join(',')
  end.join("\n")
end
