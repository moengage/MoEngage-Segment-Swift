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
public class MoEngageInitializer: NSObject {
    
    @objc public var config: MoEngageSDKConfig?
    
    public override init() {
        
    }
    
    /// Method to initialize the default instance of MoEngageSDK
    /// - Parameter sdkConfig: MoEngageSDKConfig
    @objc public func initializeDefaultInstance(sdkConfig: MoEngageSDKConfig) {
        updateSDKConfig(sdkConfig: sdkConfig)
#if DEBUG
        MoEngage.sharedInstance.initializeDefaultTestInstance(sdkConfig)
#else
        MoEngage.sharedInstance.initializeDefaultLiveInstance(sdkConfig)
#endif
        trackPluginTypeAndVersion(sdkConfig: sdkConfig)
    }
    
    /// Method to initialize the other instance of MoEngageSDK
    /// - Parameter sdkConfig: MoEngageSDKConfig
    @objc public func initializeInstance(sdkConfig: MoEngageSDKConfig) {
        updateSDKConfig(sdkConfig: sdkConfig)
#if DEBUG
        MoEngage.sharedInstance.initializeTestInstance(sdkConfig)
#else
        MoEngage.sharedInstance.initializeLiveInstance(sdkConfig)
#endif
        trackPluginTypeAndVersion(sdkConfig: sdkConfig)
    }
    
    func updateSDKConfig(sdkConfig: MoEngageSDKConfig) {
        sdkConfig.setPartnerIntegrationType(integrationType: MoEngagePartnerIntegrationType.segment)
        config = sdkConfig
    }
    
    func trackPluginTypeAndVersion(sdkConfig: MoEngageSDKConfig) {
        let integrationInfo = MoEngageIntegrationInfo(pluginType: MoEngageSegmentConstant.segment, version: MoEngageSegmentConstant.segmentVersion)
        MoEngageCoreIntegrator.sharedInstance.addIntergrationInfo(info: integrationInfo, appId: sdkConfig.moeAppID)
    }
}
