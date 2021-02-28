require_relative "./strategy"

Strategy.add 'Clone every time',
  checkout: ->(runner, ref) {
    Dir.chdir(File.dirname(runner.dir)) do
      runner.system("rm -rf #{runner.dir}")
      runner.system("git clone #{runner.remote} #{runner.dir}")
    end
    runner.system("git fetch -- origin #{ref}")
    runner.system("git checkout -f FETCH_HEAD")
    expect(runner.last_output)
      .to include("You are in 'detached HEAD' state.")
      .or include("HEAD is now at")
  }
