# Snapshots

Snapshots are archives of the `git-automation-test-suite-target` in a certain state. Automation strategies in `spec/strategies` are run against all the snapshots to check that the strategy is viable.

## Required

Repository states that the strategy is expected to handle.

## Optional

These are really weird states that strategies are not expected to be able to handle.
