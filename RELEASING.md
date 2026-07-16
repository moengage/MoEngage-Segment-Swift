# Release Process

The **Segment-MoEngage** integration is released through its own [`cd.yml`](.github/workflows/cd.yml)
GitHub Actions workflow, which runs on the shared MoEngage release pipeline. Trigger it with the
`gh` CLI; if `gh` is not authenticated, run `gh auth login` first. If the workflow fails with a
permission error, share the exact command with **@msoumya-engg-sdk** or **@umangmoe** to run it
manually.

> **You do not need to edit the release date or version manually** in [CHANGELOG.md](CHANGELOG.md) or
> [package.json](package.json). The pipeline replaces the unreleased placeholder header with the
> actual date and version, tags the release, and publishes the XCFrameworks/SPM release.

> **Distribution:** this integration is distributed via **Swift Package Manager** and **manual
> XCFramework** integration (see [README.md](README.md)) — it is not published to CocoaPods.

## Pre-flight

Do these before triggering the release:

1. Ensure [CHANGELOG.md](CHANGELOG.md) is up to date under the unreleased header (see
   [CONTRIBUTING.md](CONTRIBUTING.md#changelog)).
2. Create the [developer-docs release-notes entry](https://developers.moengage.com/hc/en-us/articles/13578297907220-iOS-Swift-Changelog)
   for the new version and keep its URL for the `note` input.
3. Decide whether the MoEngage native SDK dependency needs bumping. The compatible range lives in
   [package.json](package.json) (`sdkVerMin` / `sdkVerMax`); pass `sdk-version` only when raising the
   minimum.
4. Ensure `ci.yml` is green on `development`.

## Trigger the release

```bash
gh workflow run cd.yml \
  --repo moengage/MoEngage-Segment-Swift \
  --ref development \
  -f ticket="MOEN-XXXXX" \
  -f note="<RELEASE_NOTE_URL>" \
  -f sdk-version="<MIN_NATIVE_SDK_VERSION_OR_OMIT>"
```

- `ticket` — the release ticket id (required).
- `note` — the release-notes URL from pre-flight step 2 (required).
- `sdk-version` — the new minimum native SDK version; **omit** unless bumping the dependency.

## Monitor

```bash
gh run list  --repo moengage/MoEngage-Segment-Swift --workflow cd.yml --limit 1
gh run watch <RUN_ID> --repo moengage/MoEngage-Segment-Swift
```

## Verify

```bash
gh release list --repo moengage/MoEngage-Segment-Swift --limit 3
gh release view <VERSION> --repo moengage/MoEngage-Segment-Swift
```

Confirm the new version tag exists and the XCFramework assets are attached to the GitHub release, then
verify SPM resolution from the sample app (`MoEngageSPMApp`).

## Reference

Follow the canonical steps for the latest process:
[iOS SDK release steps — Partner release](https://moengagetrial.atlassian.net/wiki/spaces/MS/pages/3581215076/iOS+SDK+release+steps#Partner-release-steps-(applicable-to-PluginBase%2C-Segment-and-mParticle-SDK)).