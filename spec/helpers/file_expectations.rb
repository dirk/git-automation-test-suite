module FileExpectations
  def expect_main_files
    expect("present-on-first-commit.txt").to exist
    expect("present-on-second-commit.txt").to exist
    expect("present-on-other-branch-first-commit.txt").to_not exist
    expect("present-on-other-branch-second-commit.txt").to_not exist
  end

  def expect_other_branch_files
    expect("present-on-first-commit.txt").to exist
    expect("present-on-second-commit.txt").to_not exist
    expect("present-on-other-branch-first-commit.txt").to exist
    expect("present-on-other-branch-second-commit.txt").to exist
  end
end

RSpec::Matchers.define :exist do
  match do |path|
    File.file?(path)
  end
end
