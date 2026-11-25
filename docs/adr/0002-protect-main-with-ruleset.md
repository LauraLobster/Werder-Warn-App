# 0002. Protect `main` with a ruleset: PR only, green CI, squash merge

- Status: Accepted
- Date: 2026-11-25
- Issue: #14

## Context

CI (#13) runs `Analyze and test` on every pull request, but nothing prevents
merging a red PR or pushing directly to `main`. Claude Code works on this
repository with a GitHub token, so the guard rails must be enforced by GitHub,
not only written down in `CLAUDE.md`. The project has a single developer, and
PRs opened by Claude use her token, so she is the author of every PR. GitHub
does not allow authors to approve their own PR.

## Decision

A branch ruleset `Protect main`, enforcement **Active**, targets the default
branch with these rules:

- Restrict deletions
- Require linear history
- Require a pull request before merging, with **0 required approvals**,
  conversation resolution required, allowed merge method **squash** only
- Require status checks to pass: **`Analyze and test`**, branches must be up to
  date before merging
- Block force pushes

The bypass list is **empty**: the rules apply to admins too.

Repository settings: only squash merging is allowed, the squash commit uses
the PR title as its title and the PR description as its body, and head branches
are deleted automatically after merge.

The ruleset is configured by a human in the GitHub UI. The agent token has no
administration permission, so the agent cannot change its own guard rails.

## Consequences

- Nothing reaches `main` without a PR and a green CI run on the up-to-date
  branch.
- Review is a human responsibility, not enforced by GitHub, because approvals
  would block a single developer.
- `main` reads as one commit per PR; PR titles must therefore be meaningful.
- Renaming the CI job requires updating the required check in the ruleset.
- **Emergency**: if `main` must be changed without CI (e.g. CI itself is
  broken by an outside change), an admin sets the ruleset to *Disabled*, makes
  the change, and sets it back to *Active* immediately. This is a deliberate,
  visible step.
