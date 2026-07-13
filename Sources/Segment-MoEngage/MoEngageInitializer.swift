//
//  File.swift
//  
//
//  Created by Deepa on 29/12/22.
//

import Foundation
import MoEngageSDK

/// This class is used for initializing the MoEngageSDK
@objc
public final class MoEngageInitializer: NSObject {
        
    override init() {
        
    }
    
    /// Method to initialize the default instance of MoEngageSDK
    /// - Parameter sdkConfig: MoEngageSDKConfig
    @objc public static func initializeDefaultInstance(sdkConfig: MoEngageSDKConfig) {
        updateSDKConfig(sdkConfig: sdkConfig)
#if DEBUG
        MoEngage.sharedInstance.initializeDefaultTestInstance(sdkConfig)
#else
        MoEngage.sharedInstance.initializeDefaultLiveInstance(sdkConfig)
#endif
        trackPluginTypeAndVersion(sdkConfig: .init(sdkConfig))
    }

    /// Method to initialize the default instance of MoEngageSDK
    /// with data from Info.plist.
    @objc public static func initializeDefaultInstance() {
        MoEngage.sharedInstance.initializeDefaultInstance()

        guard
            let sdkConfig = try? MoEngageConfig.FileBased.fetchSDKConfigurationFromInfoPlist(),
            !sdkConfig.workspaceId.isEmpty
        else {
            MoEngageLogger.logDefault(message: "App ID is empty. Please provide a valid App ID to setup the SDK.")
            return
        }
        trackPluginTypeAndVersion(sdkConfig: sdkConfig)
    }

    /// Method to initialize the other instance of MoEngageSDK
    /// - Parameter sdkConfig: MoEngageSDKConfig
    @objc public static func initializeInstance(sdkConfig: MoEngageSDKConfig) {
        updateSDKConfig(sdkConfig: sdkConfig)
#if DEBUG
        MoEngage.sharedInstance.initializeTestInstance(sdkConfig)
#else
        MoEngage.sharedInstance.initializeLiveInstance(sdkConfig)
#endif
        trackPluginTypeAndVersion(sdkConfig: .init(sdkConfig))
    }
    
    private static func updateSDKConfig(sdkConfig: MoEngageSDKConfig) {
        sdkConfig.setPartnerIntegrationType(integrationType: MoEngagePartnerIntegrationType.segment)
    }
    
    private static func trackPluginTypeAndVersion(sdkConfig: MoEngageConfig.Data) {
        let integrationInfo = MoEngageIntegrationInfo(pluginType: .segment, version: MoEngageSegmentConstant.segmentVersion)
        MoEngageCoreIntegrator.sharedInstance.addIntergrationInfo(info: integrationInfo, appId: sdkConfig.workspaceId)
    }
}
