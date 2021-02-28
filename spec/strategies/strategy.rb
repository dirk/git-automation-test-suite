class Strategy
  class << self
    attr_accessor :strategies
    Strategy.strategies = []

    def add(name, checkout:)
      self.new(name, checkout: checkout)
        .tap { |strategy| Strategy.strategies << strategy }
    end
  end

  attr_reader :name

  def initialize(name, checkout:)
    @name = name
    @checkout_script = checkout
  end

  def checkout(ref, dir, remote, spec)
    Strategy::Runner.new(dir, remote)
      .run(@checkout_script, ref, spec)
  end
end

class Strategy::Runner
  attr_reader :dir, :remote, :last_output

  def initialize(dir, remote)
    @dir = dir
    @remote = remote
  end

  def run(script, ref, spec)
    spec.instance_exec(self, ref, &script)
  end

  def system(cmd)
    unless cmd.include?(">")
      cmd += " 2>&1"
    end
    output = `#{cmd}`
    @last_output = output
    if $?.exitstatus != 0
      message = "Command failed: #{cmd}\n"
      puts message
      puts output
      raise Strategy::CommandError, message
    end
    if ENV["VERBOSE"]
      puts output
    end
    output
  end
end

class Strategy::CommandError < StandardError
  def initialize(message)
    super
  end
end
