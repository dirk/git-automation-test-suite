module GitExpectations
  def expect_main_git_ls_files
    expect(git_ls_files).to eq %w[
      README.md
      present-on-first-commit.txt
      present-on-second-commit.txt
    ]
  end

  def expect_other_branch_git_ls_files
    expect(git_ls_files).to eq %w[
      README.md
      present-on-first-commit.txt
      present-on-other-branch-first-commit.txt
      present-on-other-branch-second-commit.txt
    ]
  end

  def git_ls_files
    `git ls-files`.strip.split("\n").sort
  end
end
