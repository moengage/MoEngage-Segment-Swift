# Contributing Guidelines

Thank you for your interest in contributing to the **Segment-MoEngage** integration! This is the
MoEngage integration for the [Segment (Twilio) Analytics-Swift](https://github.com/segmentio/analytics-swift)
SDK. It wraps the MoEngage native iOS SDK so Segment customers can route events to MoEngage.

## Table of Contents

- [Branching Strategy](#branching-strategy)
- [Project Structure](#project-structure)
  - [Sample Apps](#sample-apps)
  - [Extensions](#extensions)
- [Development / Testing Setup](#development--testing-setup)
- [Building and Testing](#building-and-testing)
- [General Guidelines](#general-guidelines)
- [Changelog](#changelog)
  - [Header](#header)
- [Raising a Pull Request](#raising-a-pull-request)

## Branching Strategy

Create your branch from an up-to-date `development` branch. Only if your change depends on another
in-flight change should you branch off that branch instead.

Branch names follow the standard MoEngage
[branching guidelines](https://moengagetrial.atlassian.net/wiki/spaces/EN/pages/5919277067/Branching+StrategyReleaseProcess):
a prefix, the Jira ticket id, then a short readable description separated by an underscore.

Example - `feature/MOEN-1234_segment-event-mapping`

All pull requests are raised against `development`.

## Project Structure

The workspace is generated with [Tuist](https://github.com/tuist/tuist). The integration source
lives under [Sources/Segment-MoEngage](Sources/Segment-MoEngage); sample apps and extensions live
under [Examples/](Examples/).

### Sample Apps

#### MoEngageSPMApp
- **Purpose**: Sample app using Swift Package Manager for dependency management.
- **Dependencies**: Segment-MoEngage (via SPM), MoEngageRichNotification (via SPM),
  NotificationService extension, NotificationContent extension.
- **Setup**: Use this app to test the Swift Package Manager integration (the default integration mode
  for customers). Make sure SPM dependencies are enabled and Tuist dependencies are disabled for
  extension targets.

#### MoEngageTuistApp
- **Purpose**: Main sample app built with Tuist to test native SDK changes before release.
- **Dependencies**: Segment-MoEngage (via Tuist), MoEngageRichNotification (via Tuist),
  NotificationService extension, NotificationContent extension.
- **Setup**: Demonstrates the full integration of MoEngage with Segment, including rich
  notifications. Make sure Tuist dependencies are enabled and SPM dependencies are disabled for
  extension targets.

#### MoEngageManualApp
- **Purpose**: Sample app with manual integration of frameworks (XCFrameworks).
- **Dependencies**: Manually added XCFramework dependencies as [described](README.md#manual-integration).
- **Setup**: Add the required XCFrameworks to this target for testing manual integration. Make sure
  Tuist and SPM dependencies are disabled for extension targets, and manually add XCFrameworks to
  extensions with the `Do not embed` option.

### Extensions

#### NotificationService
- **Purpose**: Notification service extension for rich push notifications and impression tracking.
- **Dependencies**: MoEngage-iOS-SDK (via SPM/Tuist), MoEngageRichNotification (via SPM/Tuist).
- **Setup**: Handles downloading media attachments for rich push notifications and notification
  delivery tracking.

#### NotificationContent
- **Purpose**: Notification content extension for custom notification UI.
- **Dependencies**: MoEngage-iOS-SDK (via SPM/Tuist), MoEngageRichNotification (via SPM/Tuist).
- **Setup**: Enables custom notification interfaces.

## Development / Testing Setup

1. Clone the repository.
   - When re-using an existing clone, run `git reset --hard` first so the generated project is
     regenerated cleanly.
2. Run `rake setup` to install Tuist (if needed) and generate the Xcode projects.
3. Replace XCFrameworks in [`Examples/Tuist/.build/artifacts`](Examples/Tuist/.build/artifacts) if
   required (e.g. to test against a local native SDK build).
4. Open the generated `Examples/MoEngageSegment.xcworkspace`.
5. Change the signing team to your team to run on a device.

> Run `rake -D` to see all supported tasks, and `rake -D setup` for setup options.

## Building and Testing

- Select the scheme for what you want to test:
  - `MoEngageSPMApp` — SPM integration
  - `MoEngageTuistApp` — Tuist integration
  - `MoEngageManualApp` — manual XCFramework integration
- Run the unit tests with `rake test`.
- Build the XCFrameworks with `rake xcframework`.

All apps use iOS 13.0 as the minimum deployment target and share common settings for code signing
and versioning.

## General Guidelines

- **Keep dependencies minimal.** This integration should depend only on the Segment
  Analytics-Swift SDK and the MoEngage native iOS SDK. Do not add unrelated third-party
  dependencies.
- **Match the native SDK's conventions.** Types and public APIs use the `MoEngage` prefix, file names
  match the primary type, and code uses `// MARK: -` sections and consistent indentation.
- **Deprecations:** if any public or client-facing API is deprecated or removed, mark it with
  `@available(*, deprecated, message: ...)` and note it in the [changelog](#changelog) with the new
  API equivalent.
- **Copyright header:** add the standard MoEngage copyright header to the top of every new file.
- **Guard against runtime failures.** Handle errors with `do`/`try`/`catch`; never let an exception
  from the integration crash the host app.

## Changelog

Every change adds an entry to the root [CHANGELOG.md](CHANGELOG.md). The version is tracked in
[package.json](package.json) (`frameworks[].version`).

> You do not need to fill in the release date or version manually — the release pipeline replaces the
> placeholder header with the actual date and version at release time (producing entries like
> `# 29-06-2026` / `## 2.13.0`). Your job is to add the entry bullet under the unreleased header.

### Header

Below is the header you need to add to the changelog file if it is not present already. If the header
is already present, do not add it again — just add your bullet under it.

```
# Release Date

## Release Version

```

Add your entry as a bullet under this header:

```
- <customer-readable description of the change>
- Updated MoEngage-iOS-SDK to <version>   # when the native SDK dependency is bumped
```

Most releases of this integration are native-SDK dependency bumps; describe any behavioural change to
the Segment mapping itself in its own bullet.

## Raising a Pull Request

Before raising a pull request, verify the following:

- The workspace generates cleanly (`rake setup`).
- The integration builds (`rake xcframework`).
- Unit tests pass (`rake test`).
- The change is verified in the appropriate sample app (SPM / Tuist / Manual).
- [CHANGELOG.md](CHANGELOG.md) is updated under the unreleased header.

Raise the PR against `development` with a detailed description. The PR title should be
`MOEN-<TICKET_NUMBER> : <short description of the change>`.

For the release process, see [RELEASING.md](RELEASING.md).
