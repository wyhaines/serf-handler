require "test_helper"
require 'rbconfig'

class Serf::HandlerTest < Minitest::Test
  EXEC = File.join( RbConfig::CONFIG[ 'RUBY_EXEC_PREFIX' ], 'bin', 'ruby' )

  def setup
    ENV[ 'SERF_HANDLER_CONFIG' ] = File.join( Dir.pwd,
                                              'test',
                                              'serf',
                                              '.serf-handler',
                                              'config.rb' )
  end

  def test_that_it_has_a_version_number
    refute_nil ::Serf::Handler::VERSION
  end

  def test_task
    task = Serf::Handler::Task.new( :query, 'test', 5, 'description' ) { 7 }
    assert_equal( task.type, :query )
    assert_equal( task.name, 'test' )
    assert_equal( task.order, 5 )
    assert_equal( task.description, 'description' )
    assert_equal( task.call, 7 )
  end

  def test_task_sort
    tasklist = Serf::Handler::TaskList.new

    tasklist << Serf::Handler::Task.new( :query, 'three', 3, 'I am three' ) { 3 }
    tasklist << Serf::Handler::Task.new( :query, 'seven', 7, 'I am seven' ) { 7 }
    tasklist << Serf::Handler::Task.new( :query, 'one', 1, 'I am one' ) { 1 }

    assert_equal( tasklist.first.name, 'three' )
    assert_equal( tasklist.last.name, 'one' )
    assert_equal( tasklist.sort.first.name, 'one' )
    assert_equal( tasklist.sort.last.name, 'seven' )
  end

  def test_event
    event = Serf::Handler::Event.new( { :type => :query,
                                        :name => 'test',
                                        :payload => 'arg' } )
    assert_equal( event.type, :query )
    assert_equal( event.name, 'test' )
    assert_equal( event.payload, 'arg' )

    ENV['SERF_EVENT'] = 'query'
    ENV['SERF_QUERY_NAME'] = 'test2'
    event = Serf::Handler::Event.new( { :payload => 'arg2' } )
    assert_equal( event.type, :query )
    assert_equal( event.name, 'test2' )
    assert_equal( event.payload, 'arg2' )

    ENV['SERF_EVENT'] = 'event'
    ENV['SERF_USER_EVENT'] = 'test3'
    event = Serf::Handler::Event.new( { :payload => 'arg3' } )
    assert_equal( event.type, :event )
    assert_equal( event.name, 'test3' )
    assert_equal( event.payload, 'arg3' )
  end

  def test_list_handlers
    # query: list-handlers
    # query: describe-handler
    # query: load-average
    # query: df
    # query: mpstat
    # query: ping
    result = `#{EXEC} -I lib test/serf/test-handler.rb -t query -n list-handlers -p ''`
    %w( list-handlers describe-handler load-average df mpstat ping ).each do |n|
      assert_match( /#{n}/m, result )
    end
  end

end
