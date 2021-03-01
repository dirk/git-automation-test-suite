require_relative "./strategy"

# Similar to `CleanAndCheckoutFetchHead`, but checks out the passed ref
# directly and does a `git reset` rather than always doing a detached checkout
# using the `FETCH_HEAD`.
#
# LIMITATIONS:
#
# 1. The `git reset --hard REF` command needs different arguments depending on
#    the type of the ref, meaning this strategy is not one-size-fits-all. If
#    the ref is a branch then it should be `origin/branch`, but if the ref is
#    a commit SHA-1 then it should just be the ref.
#
class Strategy::CleanAndCheckoutAndHardReset < Strategy
  def checkout(ref, branch: true)
    system("git clean -ffxdq")
    system("git fetch origin #{ref}")
    system("git checkout -f #{ref}")
    expectations do |strategy|
      expect(strategy.last_output)
        .to include("Already on")
        .or include("HEAD is now at")
        .or include("Switched to a new branch")
        .or include("Switched to branch")
        .or include("You are in 'detached HEAD' state.")
    end
    reset_ref = branch ? "origin/#{ref}" : ref
    system("git reset --hard #{reset_ref}")
    system("git clean -ffxdq")
  end
end

Strategy.add(Strategy::CleanAndCheckoutAndHardReset)
