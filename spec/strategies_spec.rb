require "fileutils"

require "spec_helper"

require_relative "./helpers/file_expectations"
require_relative "./snapshot"

# Add a require of each strategy in the strategies/ directory here.
require_relative "./strategies/clone_every_time"
require_relative "./strategies/fetch_and_clean"

root_dir = File.expand_path("../..", __FILE__)
snapshot_dir = File.join(root_dir, "tmp", "snapshot")

RSpec.describe('Strategies') do
  Strategy.strategies.each do |strategy|
    describe("Strategy: #{strategy.name}") do
      Snapshot.snapshots.each do |snapshot|
        describe("Snapshot: #{snapshot.name}") do
          include FileExpectations

          unpack = ->(&block) do
            # We'll have different remote URLs (or filesystem paths) depending
            # on how unpack configures the repository.
            remote = snapshot.unpack(snapshot_dir)
            Dir.chdir(snapshot_dir) do
              block.call(snapshot_dir, remote)
            end
          end

          it("checks out main") do
            unpack.call do |dir, remote|
              strategy.checkout("main", dir, remote, self)
              expect_main_files
            end
          end

          it("checks out other-branch") do
            unpack.call do |dir, remote|
              strategy.checkout("other-branch", dir, remote, self)
              expect_other_branch_files
            end
          end
        end
      end
    end
  end
end
