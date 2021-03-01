require_relative "./strategy"

# Cleans the repository before and after starting, and does a force detached
# checkout of the `FETCH_HEAD` to get the repo into the desired state.
class Strategy::CleanAndCheckoutFetchHead < Strategy
  def checkout(ref, branch: true)
    system("git clean -ffxdq")
    system("git fetch origin #{ref}")
    system("git checkout -f FETCH_HEAD")
    expectations do |strategy|
      expect(strategy.last_output)
        .to include("HEAD is now at")
        .or include("You are in 'detached HEAD' state.")
    end
    system("git clean -ffxdq")
  end
end

Strategy.add(Strategy::CleanAndCheckoutFetchHead)
