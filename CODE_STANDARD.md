# Segment-MoEngage — Code Standards

Conventions for the **Segment-MoEngage** integration. This is a thin wrapper that bridges the
[Segment Analytics-Swift](https://github.com/segmentio/analytics-swift) SDK to the MoEngage native
iOS SDK, so it follows the MoEngage native SDK's conventions where they apply, and Segment's
`DestinationPlugin` conventions at the integration boundary. Where a rule conflicts with habit, this
document wins.

## Table of Contents

1. [Grammar and Spelling](#1-grammar-and-spelling)
2. [Naming](#2-naming)
3. [API Visibility and Obj-C Interop](#3-api-visibility-and-obj-c-interop)
4. [Optionals and Safety](#4-optionals-and-safety)
5. [Dependencies](#5-dependencies)
6. [Testing](#6-testing)
7. [Formatting](#7-formatting)

---

## 1. Grammar and Spelling

- Spell every word correctly; a misspelled public name is a permanent, breaking-to-fix scar. Run a
  spell-check pass before a PR.
- Use **US spelling** (`initialization`, `behavior`, `color`).
- Boolean names read as a predicate: `is`, `has`, `can`, `should`, `was`.
- Follow Swift's initialism casing — acronyms are uniformly cased (`SDK`, `URL`, `ID`, `JSON`), not
  `Sdk`/`Json`.

## 2. Naming

- **Public MoEngage-facing types use the `MoEngage` prefix** and match the native SDK's style
  (e.g. `MoEngageDestination`). File names match the primary type.
- At the Segment boundary, follow Segment's plugin conventions (`DestinationPlugin`, `PluginType`,
  `Timeline`) rather than renaming them.
- Methods are `camelCase` verb phrases; prefer clear call sites per the
  [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/). Do not
  prefix simple accessors with `get`.
- Group members with `// MARK: -` sections.

## 3. API Visibility and Obj-C Interop

- Give every declaration an explicit access level; prefer the **most restrictive** that works. Keep
  the public surface as small as the Segment plugin contract requires.
- Use `@objc(...)` where the type must be discoverable from the Obj-C runtime (as `MoEngageDestination`
  does), and only there.
- Use `public internal(set)` for properties that integrators read but only the integration mutates.

## 4. Optionals and Safety

- Prefer `guard let … else { return }` early exits over nested `if let`.
- Prefer optional chaining (`?.`) and nil-coalescing (`??`) over `x != nil` checks.
- **Do not force-unwrap (`!`) or `as!`** in new code; if unavoidable, comment why it cannot be nil.
- Never let an error from the integration crash the host app — handle failures with `do`/`try`/`catch`
  and fail safe.

## 5. Dependencies

- Depend **only** on the Segment Analytics-Swift SDK and the MoEngage native iOS SDK. Do not add
  unrelated third-party dependencies.
- The compatible native SDK range is declared in [package.json](package.json) (`sdkVerMin` /
  `sdkVerMax`) and mirrored in [Package.swift](Package.swift); keep them in sync when bumping.

## 6. Testing

- Tests live under [Tests/](Tests/) and use **XCTest** (`import XCTest`).
- Name tests `test_<subject>_<condition>_<expectation>()` so the intent is greppable.
- Run the suite with `rake test`, and verify behavioural changes in the sample apps (SPM / Tuist /
  Manual) per [CONTRIBUTING.md](CONTRIBUTING.md#building-and-testing).

## 7. Formatting

- There is no SwiftLint config in this repo — follow the existing style: `MoEngage`-prefixed public
  types, `// MARK: -` sections, and consistent indentation matching the surrounding code.
- Add a file header to new files; prefer the standard MoEngage copyright header:

  ```swift
  //
  //  <FileName>.swift
  //  Segment-MoEngage
  //
  //  Created by <Author> on <dd/MM/yy>.
  //  Copyright © <Year> MoEngage. All rights reserved.
  //
  ```

- Comment only when the **why** isn't obvious from the code (a Segment/mParticle quirk, an ordering
  constraint). Don't restate what the code does or reference Jira tickets in comments.
