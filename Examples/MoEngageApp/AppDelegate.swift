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
        sdkConfig.appGroupID = "group.com.alphadevs.MoEngage.NotificationServices"
        sdkConfig.consoleLogConfig = .init(isLoggingEnabled: true, loglevel: .verbose)
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

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        MoEngageSDKMessaging.sharedInstance.userNotificationCenter(center, didReceive: response)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert , .sound])
    }
}

extension Analytics {
    static let main: Analytics = {
        let analytics = Analytics(configuration: Configuration(writeKey: "Your Write Key")
                            .flushAt(3)
                            .trackApplicationLifecycleEvents(true))
        analytics.add(plugin: MoEngageDestination())
        return analytics
    }()
}
