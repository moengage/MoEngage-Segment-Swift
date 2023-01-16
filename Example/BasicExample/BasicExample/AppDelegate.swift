//
//  AppDelegate.swift
//  BasicExample
//
//  Created by Deepa on 26/12/22.
//

import UIKit
import Segment
import Segment_MoEngage
import MoEngageSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        let sdkConfig = MoEngageSDKConfig(withAppID: "YOUR APP ID")
        sdkConfig.moeDataCenter = MoEngageDataCenter.data_center_01
        sdkConfig.appGroupID = "YOUR APP GROUP ID"
        sdkConfig.enableLogs = true
        MoEngageInitializer.initializeDefaultInstance(sdkConfig: sdkConfig)
        
        MoEngageSDKMessaging.sharedInstance.registerForRemoteNotification(withCategories: nil, andUserNotificationCenterDelegate: self)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Analytics.main.registeredForRemoteNotifications(deviceToken: deviceToken)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        Analytics.main.receivedRemoteNotification(userInfo: userInfo)
    }

}

extension Analytics {
    static var main: Analytics {
        let analytics = Analytics(configuration: Configuration(writeKey: "Your Write Key")
                            .flushAt(3)
                            .trackApplicationLifecycleEvents(true))
        analytics.add(plugin: MoEngageDestination())
        return analytics
    }
}
