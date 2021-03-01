require "fileutils"

require "spec_helper"

require_relative "./helpers/file_expectations"
require_relative "./helpers/git_expectations"
require_relative "./snapshot"

# Add a require of each strategy in the strategies/ directory here.
require_relative "./strategies/clean_and_checkout_and_hard_reset"
require_relative "./strategies/clean_and_checkout_fetch_head"
require_relative "./strategies/clone_every_time"

root_dir = File.expand_path("../..", __FILE__)
snapshot_dir = File.join(root_dir, "tmp", "snapshot")

RSpec.describe('Strategies') do
  Strategy.strategies.each do |strategy_klass|
    describe("Strategy: #{strategy_klass.short_name}") do
      Snapshot.snapshots.each do |snapshot|
        describe("Snapshot: #{snapshot.name}") do
          include FileExpectations
          include GitExpectations

          let(:unpack) do
            ->(&block) do
              # We'll have different remote URLs (or filesystem paths) depending
              # on how unpack configures the repository.
              remote_url = snapshot.unpack(snapshot_dir)
              strategy = strategy_klass.new(snapshot_dir, remote_url, self)
              Dir.chdir(snapshot_dir) do
                block.call(strategy)
              end
            end
          end

          it("checks out main") do
            unpack.call do |strategy|
              strategy.checkout("main")
              expect_main_files
              expect_main_git_ls_files
            end
          end

          it("checks out first commit by SHA-1") do
            unpack.call do |strategy|
              strategy.checkout("2a2b705bd7703fdd0e9574f1707070ff71f4fdf4", branch: false)
              expect("present-on-first-commit.txt").to exist
              expect("present-on-second-commit.txt").to_not exist
              expect(git_ls_files).to eq %w[
                README.md
                present-on-first-commit.txt
              ]
            end
          end

          it("checks out other-branch") do
            unpack.call do |strategy|
              strategy.checkout("other-branch")
              expect_other_branch_files
              expect_other_branch_git_ls_files
            end
          end
        end
      end
    end
  end
end
