require_relative "./strategy"

class Strategy::CloneEveryTime < Strategy
  def checkout(ref)
    Dir.chdir(File.dirname(repo_dir)) do
      system("rm -rf #{repo_dir}")
      system("git clone #{remote_url} #{repo_dir}")
    end
    system("git fetch -- origin #{ref}")
    system("git checkout -f FETCH_HEAD")
    expectations do |strategy|
      expect(strategy.last_output)
        .to include("You are in 'detached HEAD' state.")
        .or include("HEAD is now at")
    end
  end
end

Strategy.add(Strategy::CloneEveryTime)
