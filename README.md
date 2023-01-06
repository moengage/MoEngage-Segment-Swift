![Logo](https://github.com/moengage/MoEngage-Segment-Swift/blob/master/Images/moe_logo_blue.png)
# MoEngage-Segment-Swift

[![Version](https://img.shields.io/cocoapods/v/Segment-MoEngage.svg?style=flat)](http://cocoapods.org/pods/Segment-MoEngage)
[![License](https://img.shields.io/cocoapods/l/Segment-MoEngage.svg?style=flat)](http://cocoapods.org/pods/Segment-MoEngage)


MoEngage integration for analytics-swift.

## Installation:

MoEngage can be integrated via Segment using SPM. 
  * Add Segment Package from github URL [Analytics-Swift](https://github.com/segmentio/analytics-swift)

 ## Adding the dependency

### via Xcode
In the Xcode `File` menu, click `Add Packages`.  You'll see a dialog where you can search for Swift packages.  In the search field, enter the URL to this [repo](https://github.com/moengage/MoEngage-Segment-Swift.git).

## Setup Segment SDK:

Now head to the App Delegate file, and setup the Segment SDK by
1. Importing `Segment`, `Segment_MoEngage` and `MoEngageSDK`.
2. Initialize `MoEngageSDKConfig` object and call `initializeDefaultInstance` method of `MoEngageInitializer`.
3. Initialize `MoEngageDestination` as shown below:

Under your Analytics-Swift library setup, add the MoEngage plugin using `analytics.add(plugin: ...)` method. Now all your events will be tracked in MoEngage dashboard.

```
let analytics = Analytics(configuration: Configuration(writeKey: "<YOUR WRITE KEY>")
                    .flushAt(3)
                    .trackApplicationLifecycleEvents(true))
analytics.add(plugin: MoEngageDestination())
```

### Swift:

 ```
 import Segment_MoEngage
 import MoEngageSDK
 ...
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey:  Any]?) -> Bool {
 ...
 
     let sdkConfig = MoEngageSDKConfig(withAppID: "YOUR APP ID")
     MoEngageInitializer.shared.initializeDefaultInstance(sdkConfig: sdkConfig)
     MoEngage.sharedInstance.enableSDK()
     
     // Add your configuration key from Segment
     let analytics = Analytics(configuration: Configuration(writeKey: "<YOUR WRITE KEY>")
                    .flushAt(3)
                    .trackApplicationLifecycleEvents(true))
     // Add Moengage Destination Plugin to send data from Segment to MoEngage
     analytics.add(plugin: MoEngageDestination())
 ...
 }
 ```

## Setup MoEngage in Segment Dashboard:

To setup MoEngage do the following : 
  1. First get your key from MoEngage dashboard. (Dashboard -> Settings -> General -> General Settings -> AppID)
  2. Go to **Segment dashboard**, go to **Integrations** and select **MoEngage**. 
  3. Enable MoEngage Integration.
  4. Go to MoEngage Settings and enter the MoEngage AppID, obtained in **Step1**.
  5. Save the changes.
  
  ![Segment Dashboard Settings](https://user-images.githubusercontent.com/15011722/31998605-085158de-b9ae-11e7-9729-c637b6bbc083.png)
  
These new settings will take up to an hour to propogate to all of your existing users. For new users it’ll be instanteneous! Segment-MoEngage Integration is a bundled integration, requires client side integration.

## Tracking User Attribute

User attributes are specific traits of a user, like email, username, mobile, gender etc. **identify** lets you tie a user to their actions and record traits about them. It includes a unique User ID and any optional traits you know about them.

 ```Analytics.main.identify(userId: "a user's id", traits: ["email": "a user's email address"])```

For more info refer to this [link](https://segment.com/docs/sources/mobile/ios/#identify).

## Tracking Events

Event tracking is used to track user behaviour in an app. **track** lets you record the actions your users perform. Every action triggers i.e,“event”, which can also have associated attributes.

 ```Analytics.main.track(name: "Item Purchased", properties: ["item": "Sword of Heracles"])```

That's all you need for tracking data. For more info refer this [link](https://segment.com/docs/sources/mobile/ios/#track).

## Reset Users

The *reset* method clears the SDK’s internal stores for the current user. This is useful for apps where users can log in and out with different identities over time.

 ```Analytics.main.reset()```

For more info refer to this [link](https://segment.com/docs/sources/mobile/ios/#reset).

## Install / Update Differentiation 

Since you might integrate us when your app is already on the App Store, we would need to know whether your app update would be an actual UPDATE or an INSTALL.
To differentiate between those, use one of the method below:

 ```
 //For new Install call following
 MoEngageSDKAnalytics.sharedInstance.appStatus(.install);

 //For an app update call following
 MoEngageSDKAnalytics.sharedInstance.appStatus(.update);
 ```

For more info on this refer following [link](https://developers.moengage.com/hc/en-us/articles/4403910297620).

## Using features provided in MoEngage SDK

Along with tracking your user's activities, MoEngage iOS SDK also provides additional features which can be used for more effective user engagement:

### Push Notifications:
Push Notifications are a great way to keep your users engaged and informed about your app. You have following options while implementing push notifications in your app:

#### Segment Push Implementation:

1.Follow the directions to register for push using Segment SDK in this [link](https://segment.com/docs/libraries/ios/#how-do-i-use-push-notifications-).

2.In your application’s application:didReceiveRemoteNotification: method, add the following:

 ```Analytics.main.receivedRemoteNotification(userInfo: userInfo)```

3.If you integrated the application:didReceiveRemoteNotification:fetchCompletionHandler: in your app, add the following to that method:
 
 ```Analytics.main.receivedRemoteNotification(userInfo: userInfo)```
 
#### MoEngage Push Implementation:
 Follow this link to implement Push Notification in your mobile app using MoEngage SDK : 
 [**Push Notifications**](https://developers.moengage.com/hc/en-us/articles/4403943988756)


### In-App Messaging:

In-App Messaging are custom views which you can send to a segment of users to show custom messages or give new offers or take to some specific pages. Follow the link to know more about  inApp Messaging and how to implement it in your application: 
[**InApp NATIV**](https://developers.moengage.com/hc/en-us/articles/4404155127828-In-App-Nativ)

## Segment Docs:
For more info on using **Segment for iOS** refer to [**Developer Docs**](https://segment.com/docs/sources/mobile/ios/) provided by Segment.
  
## Change Log
See [SDK Change Log](https://github.com/moengage/MoEngage-Segment-iOS/blob/master/CHANGELOG.md) for information on every released version.

## Support
For any issues you face with the SDK and for any help with the integration contact us at `support@moengage.com`.
