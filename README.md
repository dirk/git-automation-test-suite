# Git Automation Test Suite

This is a suite of tests to verify the completeness of Git automation strategies. It contains snapshots of Git repositories in various states, and tests the ability of automated Git commands to get from those initial states to the final desired state.

This is useful for writing Git automation for continuous integration, deployment, and other scenarios where local Git repositories must be automated. If a strategy in this repo passes all the tests, then it should be able to check out a given Git branch from a remote.

## License

Licensed under the 3-clause BSD license. See [LICENSE](LICENSE) for details.
