# Serf::Handler

Serf (https://www.serf.io/) is a decentralized tool, by HashiCorp, for managing
cluster membership, failure detection, and Orchestration. One of Serf's key
features is the ability to issue queries and trigger events on other agents
in the cluster. Serf can run arbitrary handlers in order to handle these
queries and events.

This package encapsulates a small, simple library to facilitate writing flexible
Serf handlers with Ruby. Also included in the package is a set of prebuilt
handlers which can be used immediately in your own Serf cluster.

## Usage

```ruby
require 'serf/handler'

Serf::Handler.run
```

No additional code is necessary to implement a Serf handler. This basic
implementation is available in `bin/serf-handler.rb`.

Specific query/event handlers are implemented as Ruby classes, by `include`ing
`Serf::Handler` into your class. A very basic DSL is provided to aid
implementation.

```ruby
require 'serf/handler'
include Serf::Handler

describe "Provide a list of all available handlers."

on :query, 'list-handlers', 0 do |event|
  Serf::Handler::Tasks.collect do |task|
    "#{task.type}: #{task.name}\n"
  end.join
end
```

* `describe`: Attach a human readable description to whatever event is defined next.
* `on`: Takes two, or, optionally, three arguments (type, name, order) to describe the task, and a block that implements the task.

When a query or an event is received by the handler, it will run any tasks with
a matching type that do not have a name, in an order described by sorting the
tasks numerically on their order value. The default value for order, if not
given, is 0. It will then run any named task or tasks with a matching name.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake test` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/wyhaines/serf-handler.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
