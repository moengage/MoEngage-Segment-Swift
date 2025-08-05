Releasing
=========

1. Make sure CHANGELOG for each module is up to date, from the CHANGELOGs determine the new version to be released.
1. Create [developer docs release notes entry](https://developers.moengage.com/hc/en-us/articles/13578297907220-iOS-Swift-Changelog) for the new release.
1. Trigger workflow [`cd.yml`](.github/workflows/cd.yml) from development branch with input:
    - note: as the link to new release note entry created in previous step.
    - ticket: as the release ticket id.
    - sdk-version: as the minimum SDK version (if dependency needs to be updated).

> [!NOTE]
> Follow doc for latest steps: https://moengagetrial.atlassian.net/wiki/spaces/MS/pages/3581215076/iOS+SDK+release+steps#Partner-release-steps-(applicable-to-PluginBase%2C-Segment-and-mParticle-SDK)
