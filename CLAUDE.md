# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Project

**Werder Warn App** warns Bremen residents on Werder Bremen home match days,
so they can avoid the city centre. Flutter app for Android and iOS.
Product backlog lives in GitHub issues (epic: #1). Issues are written in German;
code, commits, PRs and docs are written in English.

## Commands

```bash
flutter pub get                          # install dependencies
flutter analyze                          # must report "No issues found!"
flutter test                             # run all tests
flutter test test/<path>/<file>_test.dart  # run a single test file
dart format .                            # format code
```

CI (`.github/workflows/ci.yaml`) runs on every PR and on every push to `main`.
Run the same checks locally before pushing:

```bash
flutter pub get --enforce-lockfile
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

In the sandbox there is no Android SDK or Xcode: do not try `flutter run` or
`flutter build`. Analyze and test are the feedback loop.

## Workflow (strict TDD)

Every change starts from a GitHub issue and follows this sequence:

1. Read the issue (`gh issue view <n>`) and its acceptance criteria.
   Ask if anything is unclear before writing code.
2. Create a branch from `main`: `<type>/<issue>-<slug>`,
   e.g. `feat/3-filter-home-matches`. Types: `feat`, `fix`, `refactor`, `docs`,
   `test`, `chore`.
3. **Red**: write one failing test for one behaviour. Run it and show that it
   fails for the expected reason.
4. **Green**: write the minimal code that makes it pass.
5. **Refactor**: clean up production and test code against the
   [Clean Code](#clean-code) rules while staying green.
6. Repeat 3–5 until the acceptance criteria are covered.
7. Run `flutter analyze` and `flutter test`; both must be clean.
8. Commit, push the branch and open a PR with `Closes #<n>`.

A bug fix starts with a test that reproduces the bug.

## Architecture

State management is **Bloc** (see [ADR 0001](docs/adr/0001-bloc-and-feature-first-structure.md)).
Layers follow the [bloc architecture](https://bloclibrary.dev/architecture/);
dependencies point downwards only:

```
Presentation (widgets)  →  Business logic (Bloc/Cubit)  →  Repository  →  Data source
```

- Widgets never access repositories or data sources directly.
- Blocs know nothing about widgets or `BuildContext`.
- Blocs do not talk to each other directly; they share data through
  repositories or are coordinated by the presentation layer.
- Repositories, data sources and domain logic (e.g. filtering home matches,
  computing the warning time 4 h before kick-off) are pure Dart: no Flutter
  imports.
- Inject time, network and storage. Never call `DateTime.now()` directly in
  logic; pass a clock so tests are repeatable.

### Folder structure

Feature-first, following the Very Good Ventures layout:

```
lib/
  main.dart
  app/                      # app widget, theme, repository wiring
    view/app.dart
  <feature>/                # e.g. schedule/, notifications/
    bloc/ or cubit/         # <feature>_bloc.dart, _event.dart, _state.dart
    view/                   # <feature>_page.dart (provides the bloc), <feature>_view.dart
    widgets/
    <feature>.dart          # barrel file
  data/                     # shared, not per feature
    <name>_api/             # data source: API client and its models (pure Dart)
    <name>_repository/      # repository and domain models (pure Dart)
test/                       # mirrors lib/ one to one
```

`data/*` may later move into separate packages under `packages/`.

### Bloc conventions

- Use a **Cubit** by default. Use a **Bloc** (events) when events need
  transforming (debounce, concurrency) or event traceability matters.
- States are immutable and comparable (`equatable`); model status with an enum
  or `sealed` classes.
- Test blocs and cubits with `bloc_test`, mock with `mocktail`, test views with
  widget tests.

### Dependencies and decisions

- Ask before adding any dependency to `pubspec.yaml`. Bloc packages
  (`flutter_bloc`, `bloc`, `equatable`, `bloc_test`, `mocktail`) are added with
  the first story that needs them.
- Record every architectural decision as a new ADR in `docs/adr/`
  (`NNNN-short-title.md`: Context, Decision, Consequences).

## Clean Code

Robert C. Martin's *Clean Code* is the guideline for all code and every review.
The refactor step of each TDD cycle checks the code against this list.

- **Names**: meaningful and pronounceable; no abbreviations or type prefixes.
  Classes are nouns, methods are verbs. Use the domain language
  (`Match`, `HomeMatch`, `kickoff`, `warningTime`).
- **Functions**: small, do one thing, one level of abstraction (stepdown rule).
  At most two parameters, otherwise a parameter object. No boolean flag
  parameters, no hidden side effects. Separate commands from queries.
- **Classes**: single responsibility, small, highly cohesive. Follow the Law of
  Demeter. Inject dependencies through the constructor.
- **Comments**: code explains itself; comments explain only *why*. No
  commented-out code, no redundant or template comments.
- **Error handling**: use exceptions or typed results instead of error codes.
  Avoid returning or passing `null` where a better type exists.
- **DRY** and the **Boy Scout Rule**: leave code you touch cleaner than you
  found it, within the scope of the issue. Larger clean-ups get their own issue.
- **Clean tests**: F.I.R.S.T. (fast, independent, repeatable, self-validating,
  timely); one concept per test; arrange–act–assert; test code is as clean as
  production code.

If a Clean Code rule conflicts with a lint rule, the lint wins; point out the
conflict.

## Code style

- Follow `very_good_analysis` (configured in `analysis_options.yaml`) and
  `dart format`.
- Do not add `// ignore:` comments or weaken lint rules without a stated reason
  and approval.

## Git and GitHub

- Never commit or push to `main`. Never merge, force-push or rewrite shared
  history; merging is done by a human after review.
- Commit messages: English, imperative mood, reference the issue,
  e.g. `Add home match filter (#3)`.
- PR description: summary of the change, how it was tested
  (analyze/test output), and `Closes #<n>`.
- `origin` uses SSH; from the sandbox push via HTTPS:
  `git push https://github.com/LauraLobster/Werder-Warn-App.git <branch>`.
- Changes under `.github/workflows/` are pushed by a human: the agent token
  deliberately has no "Workflows" permission. Commit locally and ask the user
  to push.
- `main` is protected by a ruleset
  ([ADR 0002](docs/adr/0002-protect-main-with-ruleset.md)): changes land only
  through a PR with a green `Analyze and test` check, merged by squash.
- The PR title becomes the commit message on `main`: write it in English,
  imperative mood, with the issue number, e.g. `Add home match filter (#3)`.
- If a branch is behind `main`, merge `main` into it (or use "Update branch"
  in the PR). Never force-push.
- Do not rename the `Analyze and test` job in `ci.yaml` without updating the
  ruleset; otherwise every PR is blocked waiting for a check that never runs.

## Definition of Done

An issue is done when:

- [ ] its acceptance criteria are covered by tests,
- [ ] the code was checked against the Clean Code rules in the refactor step,
- [ ] `flutter analyze` reports no issues,
- [ ] `flutter test` passes and CI is green,
- [ ] the PR references the issue with `Closes #<n>`,
- [ ] decisions are recorded as an ADR or in the README,
- [ ] no secrets are in the repository.

## Security

- Never write tokens, passwords or other credentials into files, commits, PRs
  or issue comments.
- The GitHub token in the sandbox is scoped to this repository (issues and pull
  requests). Do not try to widen access.
