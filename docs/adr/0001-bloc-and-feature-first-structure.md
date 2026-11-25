# 0001. Bloc for state management and a feature-first folder structure

- Status: Accepted
- Date: 2026-11-25
- Issue: #12

## Context

Before the first story (#2–#4) is implemented, the app needs a state
management approach and a folder structure that Claude Code and humans follow
consistently. The project uses strict TDD and treats Robert C. Martin's
*Clean Code* as its guideline, so business logic must be easy to test in
isolation. The project already uses `very_good_analysis`.

## Decision

- Use **Bloc** (`flutter_bloc`) for state management. Cubit is the default;
  Bloc with events is used when event transformation or traceability is needed.
- Use the layered [bloc architecture](https://bloclibrary.dev/architecture/):
  presentation → business logic → repository → data source, with dependencies
  pointing downwards only.
- Organise `lib/` **feature-first** following the Very Good Ventures layout
  (`<feature>/{bloc|cubit,view,widgets}`), with shared data sources and
  repositories in `lib/data/`. Repositories, data sources and domain logic are
  pure Dart.
- Keep the data layer inside `lib/` for now instead of separate packages under
  `packages/`, to avoid overhead in a small app.

## Consequences

- Business logic can be unit-tested without Flutter; blocs are tested with
  `bloc_test`, dependencies mocked with `mocktail`.
- New dependencies are needed (`flutter_bloc`, `bloc`, `equatable`,
  `bloc_test`, `mocktail`); they are added with the first story that uses them.
- Each feature is self-contained, which matches the story-based backlog.
- If the data layer grows, `lib/data/*` can be moved into packages under
  `packages/` without changing the dependency rules.

## Addendum (2026-11-25, #2): features map to epics

A feature folder in `lib/` corresponds to one epic, e.g. `home_match_warning/`
for epic #1. Stories get no feature folder of their own; temporary screens such
as the home match list live in the epic's feature until it is replaced. Data
modules in `lib/data/` follow the package layout of a barrel file plus `src/`.
