require_relative "./strategy"

# Wipes out the old repo and does a fresh clone from the remote every time.
#
# LIMITATIONS:
#
# 1. This is extremely inefficient!
#
class Strategy::CloneEveryTime < Strategy
  def checkout(ref, branch: true)
    Dir.chdir(File.dirname(repo_dir)) do
      system("rm -rf #{repo_dir}")
      system("git clone #{remote_url} #{repo_dir}")
    end
    system("git fetch origin #{ref}")
    system("git checkout FETCH_HEAD")
    expectations do |strategy|
      expect(strategy.last_output)
        .to include("HEAD is now at")
        .or include("You are in 'detached HEAD' state.")
    end
  end
end

Strategy.add(Strategy::CloneEveryTime)
