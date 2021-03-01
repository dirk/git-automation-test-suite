require_relative "./strategy"

class Strategy::FetchAndClean < Strategy
  def checkout(ref)
    system("git clean -ffxdq")
    system("git fetch -- origin #{ref}")
    system("git checkout -f FETCH_HEAD")
    expectations do |strategy|
      expect(strategy.last_output)
        .to include("You are in 'detached HEAD' state.")
        .or include("HEAD is now at")
    end
    system("git clean -ffxdq")
  end
end

Strategy.add(Strategy::FetchAndClean)
