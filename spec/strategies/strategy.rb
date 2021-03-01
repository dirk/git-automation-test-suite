class Strategy
  attr_reader :repo_dir, :remote_url, :spec

  attr_reader :last_output

  def initialize(repo_dir, remote_url, spec)
    @repo_dir = repo_dir
    @remote_url = remote_url
    @spec = spec
  end

  class << self
    attr_accessor :strategies
    Strategy.strategies = []

    def add(klass)
      self.strategies << klass
    end

    def short_name
      name.split("::").last
    end
  end

  # Abstract method, should be implemented by each strategy subclass.
  def checkout(ref, branch: true)
    raise
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

  def expectations(&block)
    spec.instance_exec(self, &block)
  end
end

class Strategy::CommandError < StandardError
  def initialize(message)
    super
  end
end
