require_relative "./strategy"

Strategy.add 'Fetch and clean',
  checkout: ->(runner, ref) {
    runner.system("git clean -ffxdq")
    runner.system("git fetch -- origin #{ref}")
    runner.system("git checkout -f FETCH_HEAD")
    expect(runner.last_output)
      .to include("You are in 'detached HEAD' state.")
      .or include("HEAD is now at")
    runner.system("git clean -ffxdq")
  }
