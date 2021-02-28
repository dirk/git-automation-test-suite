require "json"

class Snapshot
  GITHUB_REMOTE = "git@github.com:dirk/git-automation-test-suite-target.git"

  class << self
    def snapshots
      return @snapshots unless @snapshots.nil? || @snapshots.empty?
      root_dir = File.expand_path("../..", __FILE__)
      snapshots_dir = File.join(root_dir, "snapshots")
      required = list_snapshots(File.join(snapshots_dir, "required"))
      optional = list_snapshots(File.join(snapshots_dir, "optional"), optional: true)
      @snapshots = required.concat(optional)
    end

    def list_snapshots(dir, optional: false)
      Dir[File.join(dir, "*", "snapshot.tar.gz")]
        .map { |snapshot_file|
          manifest_file = File.expand_path("../manifest.json", snapshot_file)
          manifest = JSON.parse(File.read(manifest_file))
          Snapshot.new(snapshot_file, manifest, optional)
        }
    end
  end

  def initialize(snapshot_file, manifest, optional)
    @snapshot_file = snapshot_file
    @manifest = manifest
    @optional = optional
  end

  # By default this will use a local copy of the remote so that we're not
  # sending a ton of traffic to GitHub.
  def unpack(dir, github: false)
    FileUtils.rm_rf(dir)
    FileUtils.mkdir(dir)
    system("tar xzvf #{@snapshot_file} -C #{dir} 2>&1")
    if github
      GITHUB_REMOTE
    else
      root_dir = File.expand_path("../..", __FILE__)
      remote_dir = File.join(root_dir, "tmp", "remote.git")
      unless File.directory?(remote_dir)
        puts "Missing local remote; please run:\n\n"
        puts "  git clone --mirror #{GITHUB_REMOTE} #{remote_dir}\n\n"
        raise "Local remote missing"
      end
      Dir.chdir(dir) do
        system("git remote set-url origin #{remote_dir}")
      end
      remote_dir
    end
  end

  def system(cmd)
    output = `#{cmd}`
    if $?.exitstatus != 0
      message = "Command failed: #{cmd}\n"
      puts message
      puts output
      raise message
    end
    output
  end

  def name
    @manifest.fetch("name")
  end

  def optional?
    @optional
  end

  def required?
    !@optional
  end
end
