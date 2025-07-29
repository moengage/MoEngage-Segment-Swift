# Contributing to MoEngageSegment

Thank you for your interest in contributing to the MoEngageSegment project! This guide will help you understand the project structure and get you started with development.

## Project Structure

The project is built using Tuist and consists of several targets:

### Sample Apps

#### MoEngageSPMApp
- **Purpose**: Sample app using Swift Package Manager for dependency management
- **Dependencies**: 
  - Segment-MoEngage (via SPM)
  - MoEngageRichNotification (via SPM)
  - NotificationService extension
  - NotificationContent extension
- **Setup**: 
  - Use this app to test the Swift Package Manager integration (default integration mode for customer)
  - Make sure SPM dependencies are enabled and Tuist dependencies are disabled for extension targets

#### MoEngageTuistApp
- **Purpose**: Main sample app built with Tuist to test native SDK changes before release
- **Dependencies**: 
  - Segment-MoEngage (via Tuist)
  - MoEngageRichNotification (via Tuist)
  - NotificationService extension
  - NotificationContent extension
- **Setup**:
  - This app demonstrates the full integration of MoEngage with Segment, including rich notifications
  - Make sure Tuist dependencies are enabled and SPM dependencies are disabled for extension targets

#### MoEngageManualApp
- **Purpose**: Sample app with manual integration of frameworks (XCFrameworks)
- **Dependencies**: Manually add XCFramework dependencies as [described](README.md#manual-integration).
- **Setup**: 
  - Add the required XCFrameworks to this target for testing manual integration
  - Make sure Tuist and SPM dependencies are disabled for extension targets, manually add XCFrameworks to extensions with `Do not embed` option.

### Extensions

#### NotificationService
- **Purpose**: Notification service extension for rich push notifications and impression tracking
- **Dependencies**: 
  - MoEngage-iOS-SDK (via SPM/Tuist)
  - MoEngageRichNotification (via SPM/Tuist)
- **Setup**: This extension handles downloading media attachments for rich push notifications and notification delivery tracking

#### NotificationContent
- **Purpose**: Notification content extension for custom notification UI
- **Dependencies**: 
  - MoEngage-iOS-SDK (via SPM/Tuist)
  - MoEngageRichNotification (via SPM/Tuist)
- **Setup**: This extension enables custom notification interfaces

## Development or Testing Setup

1. Clone the repository
  - Run `git reset--hard` when running with existing clone. 
1. Run `rake setup` to generate the Xcode projects
1. Replace XCFrameworks in [`Examples/Tuist/.build/artifacts`](Examples/Tuist/.build/artifacts) if required.
1. Open the generated `Examples/MoEngageSegment.xcworkspace` file
1. Change team to your team to run the app on device.

## Building and Testing

- Select the appropriate scheme based on what you want to test:
  - `MoEngageSPMApp` for SPM integration
  - `MoEngageTuistApp` for Tuist integration
  - `MoEngageManualApp` for manual XCFramework integration

## Making Contributions

1. Create a new branch for your feature or bugfix,
  - branch name should have ticket id prefix with and underscore separating ticket id from readable name
1. Make your changes
1. Test with the appropriate sample app
1. Submit a pull request to `development` branch with a detailed description of your changes

## Project Settings

All apps use iOS 13.0 as the minimum deployment target and share common settings for code signing and versioning.

## Additional Resources

See the project's README.md for more information on usage and requirements.
