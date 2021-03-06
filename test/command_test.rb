# Copyright (c) 2007-2012 Vassilis Rizopoulos. All rights reserved.
# Copyright (c) 2021 Markus Prasser. All rights reserved.

require 'test_helper'
require 'batir/command'

class MockCommandObject
  include Batir::Command
end

class MockCommandWarning
  include Batir::Command
  def run context=nil
    @status=:warning
    return :warning
  end
end

class MockCommandError
  include Batir::Command
  def run context=nil
    @status=:error
    return :error
  end
end

module Batir::Test
  ##
  # Test the Batir::Command module
  class Command < Minitest::Test
    ##
    # Verify that the module's default values are correctly set
    def test_default_values
      obj = MockCommandObject.new
      assert_equal('', obj.backtrace)
      assert_equal('', obj.error)
      assert_equal(0, obj.exec_time)
      refute(obj.executed?)
      assert_equal('', obj.name)
      assert_nil(obj.number)
      assert_equal('', obj.output)
      refute(obj.run?)
      assert_equal(:not_executed, obj.status)
      assert_nil(obj.strategy)
      refute(obj.success?)
    end

    ##
    # Verify that the Batir::Command#reset method correctly resets its fields
    def test_reset
      obj = MockCommandObject.new
      obj.backtrace = "Something\nbad\nhappened"
      obj.error = 'Ouch'
      obj.exec_time = 182
      obj.output = 'Some characters'
      obj.status = :some_state
      assert_equal("Something\nbad\nhappened", obj.backtrace)
      assert_equal('Ouch', obj.error)
      assert_equal(182, obj.exec_time)
      assert_equal('Some characters', obj.output)
      assert_equal(:some_state, obj.status)
      obj.reset
      assert_equal('', obj.backtrace)
      assert_equal('', obj.error)
      assert_equal(0, obj.exec_time)
      assert_equal('', obj.output)
      assert_equal(:not_executed, obj.status)
    end

    ##
    # Verify that the Batir::Command#run method correctly updates the status
    def test_run
      obj = MockCommandObject.new
      assert_equal(:not_executed, obj.status)
      obj.run
      assert(obj.executed?)
      assert(obj.run?)
      assert_equal(:success, obj.status)
    end
  end

  ##
  # Test the Batir::ShellCommand class
  class ShellCommand < Minitest::Test
    include Batir

    ##
    # Clean-up after each test case
    def teardown
      File.delete('missing/test.txt') if File.exist?('missing/test.txt')
      Dir.delete('missing/') if Dir.exist?('missing/')
    end

    ##
    # Verify that a Batir::ShellCommand is correctly initialized
    def test_initialize
      cmd = Batir::ShellCommand.new(cmd: 'some_cmd',
                                    name: 'ini_test_cmd',
                                    timeout: 32,
                                    working_directory: '/test')
      assert_equal('', cmd.error)
      assert_equal('ini_test_cmd', cmd.name)
      assert_equal('', cmd.output)
      assert_equal(:not_executed, cmd.status)

      # Command and working directory can only be checked through
      # stringification
      assert_equal('ini_test_cmd: some_cmd in /test', cmd.to_s)
    end

    ##
    # Verify the successful execution of a command
    def test_echo
      assert(cmd = Batir::ShellCommand.new(cmd: 'sleep 5 && echo hello'))
      assert_instance_of(Batir::ShellCommand, cmd)
      refute(cmd.run?)
      refute(cmd.success?)
      assert(cmd.run)
      assert(cmd.run?)
      assert(cmd.success?)
      assert_equal("hello\n", cmd.output)
      assert_equal('', cmd.error)
      assert_equal(:success, cmd.status)
      assert_in_epsilon(5, cmd.exec_time, 0.1)
    end

    ##
    # Verify that the error status is correctly reported if a
    # Batir::ShellCommand fails
    def test_error
      assert(cmd = Batir::ShellCommand.new(cmd: 'touch /non_existent/file.txt'))
      refute(cmd.run?)
      refute(cmd.success?)
      assert(cmd.run)
      assert(cmd.run?)
      refute(cmd.success?)
      assert_equal(:error, cmd.status)
      refute(cmd.error.empty?)
    end

    ##
    # Verify that if the command is being passed a working directory it should
    # change into it
    def test_cwd
      assert(cmd = Batir::ShellCommand.new(cmd: 'touch test.txt',
                                           working_directory: 'missing/'))
      assert(cmd.run)
      assert(cmd.success?)
      assert(File.exist?('missing/test.txt'))
    end

    ##
    # Verify that if the working directory is missing it is being created when
    # the command is run
    def test_missing_cwd
      assert(cmd = Batir::ShellCommand.new(cmd: 'echo hello',
                                           working_directory: 'missing/'))
      assert_instance_of(Batir::ShellCommand, cmd)
      assert_equal(:success, cmd.run)
      assert(cmd.success?)
      assert(Dir.exist?('missing/'))
    end

    ##
    # Verify that ParameterException is raised when +:cmd+ is +nil+
    def test_missing_cmd
      assert_raises(ParameterException) do
        Batir::ShellCommand.new(working_directory: 'missing/')
      end
    end

    ##
    # Verify correct execution handling with the +ls+ utility
    def test_ls
      cmd = Batir::ShellCommand.new(cmd: 'ls')
      refute(cmd.run?)
      refute(cmd.success?)
      assert(cmd.run)
      assert(cmd.run?)
      if cmd.success?
        refute_equal('', cmd.output)
      else
        refute_equal('', cmd.error)
      end
    end

    ##
    # Verify that hitting a timeout causes the execution to fail
    def test_timeout
      cmd = Batir::ShellCommand.new(cmd: "ruby -e 't=0;while t<10 do p t;" \
                                         "t+=1;sleep 1 end '",
                                    timeout: 1)
      assert(cmd.run)
      assert(cmd.run?, 'Should be marked as run')
      assert(!cmd.success?, 'Should not have been successful')
      assert(!cmd.error.empty?, 'There should be an error message')
      # Test also for an exit within the timeout
      cmd = Batir::ShellCommand.new(cmd: "ruby -e 't=0;while t<1 do p t;" \
                                         "t+=1;sleep 1 end '",
                                    timeout: 4)
      assert(cmd.run)
      assert(cmd.run?, 'Should be marked as run')
      assert(cmd.success?, 'Should have been successful')
      assert(cmd.error.empty?, 'There should be no error messages')
    end

    ##
    # Verify that Batir::ShellCommand fails if the executable cannot be found
    def test_missing_executable
      cmd = Batir::ShellCommand.new(cmd: 'bla')
      refute(cmd.run?)
      refute(cmd.success?)
      assert(cmd.run)
      refute(cmd.success?, 'Should fail if the executable is missing')

      cmd = Batir::ShellCommand.new(cmd: '"With spaces" and params')
      refute(cmd.run?)
      refute(cmd.success?)
      assert(cmd.run)
      refute(cmd.success?, 'Should fail if the executable is missing')
    end
  end

  ##
  # Test the Batir::RubyCommand class
  class RubyCommand < Minitest::Test
    include Batir

    ##
    # Verify that Batir::RubyCommand is correctly initialized with a working
    # directory being given
    def test_initialization_with_working_directory
      sleep_cmd = lambda { sleep 1 }
      cmd = Batir::RubyCommand.new('test_cmd', 'example/path', &sleep_cmd)
      assert_equal(sleep_cmd, cmd.cmd)
      assert_equal('test_cmd', cmd.name)
      assert_equal('example/path', cmd.working_directory)
    end

    ##
    # Verify that Batir::RubyCommand raises if no block is being given
    def test_initialization_without_block
      exc = assert_raises(RuntimeError) do
        Batir::RubyCommand.new('test_cmd')
      end
      assert_equal('You need to provide a block', exc.message)
    end

    ##
    # Verify that Batir::RubyCommand is correctly initialized without a working
    # directory being given
    def test_initialization_without_working_directory
      sleep_cmd = lambda { sleep 1 }
      cmd = Batir::RubyCommand.new('test_cmd', &sleep_cmd)
      assert_equal(sleep_cmd, cmd.cmd)
      assert_equal('test_cmd', cmd.name)
      assert_equal('.', cmd.working_directory)
    end

    ##
    # Verify the outcome of a successful block execution
    def test_successful_execution
      cmd = Batir::RubyCommand.new('test') { sleep 1 }
      assert_equal(:success, cmd.run)
      assert_equal('', cmd.backtrace)
      assert_nil(cmd.context)
      assert_equal('', cmd.error)
      assert_in_delta(1, cmd.exec_time, 0.05)
      assert_equal('', cmd.output)
      assert_equal(:success, cmd.status)
      assert(cmd.success?)
    end

    ##
    # Verify that exceptions are correctly handled during the execution of a
    # command
    def test_exeption_handling
      cmd = Batir::RubyCommand.new('test') do
        sleep 1
        raise 'An error happened'
        sleep 1
      end
      assert(cmd.run('context does not matter'))
      assert_nil(cmd.context)
      assert_in_delta(1, cmd.exec_time, 0.05)
      refute(cmd.success?)
      assert_match(/^\[".*`block in autorun'"\]$/, cmd.backtrace.to_s)
      assert_equal("\nAn error happened", cmd.error)
      assert_equal(:error, cmd.status)
    end

    ##
    # Verify that an execution context is correctly handled
    def test_execution_context_handling
      context = 'complex'
      cmd = Batir::RubyCommand.new('test') { |c| c.output = c.context }
      assert_equal(:success, cmd.run(context))
      assert_equal('', cmd.backtrace)
      assert_nil(cmd.context)
      assert_equal('', cmd.error)
      assert_in_delta(0, cmd.exec_time, 0.05)
      assert_equal('complex', cmd.output)
      assert_equal(:success, cmd.status)
      assert(cmd.success?)
      assert_equal(:success, cmd.run('simple'))
      assert_equal('simple', cmd.output)
    end
  end
end
