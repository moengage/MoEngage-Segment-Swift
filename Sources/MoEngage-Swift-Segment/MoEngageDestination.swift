import Segment
import MoEngageSDK
import UIKit

@objc
public class MoEngageDestination: UIResponder, DestinationPlugin {
    public let timeline = Timeline()
    public let type = PluginType.destination
    public let key = MoEngageDestinationConstant.destinationKey
    
    public var analytics: Analytics?
    private var moengageSettings: MoEngageSettings?
    
    public override init() {
    }
    
    public func update(settings: Settings, type: UpdateType) {
        guard type == .initial else { return }
        
        guard let tempSettings: MoEngageSettings = settings.integrationSettings(forPlugin: self) else { return }
        moengageSettings = tempSettings
        
        guard let appID = moengageSettings?.apiKey else {
            MoEngageLogger.logDefault(message: "App ID not present")
            return
        }
        
        MoEngageCoreIntegrator.sharedInstance.enableSDKForPartner(workspaceId: appID, integrationType: .segment)
        
        DispatchQueue.main.async {
            if let segmentAnonymousID = self.analytics?.anonymousId {
                MoEngageSDKAnalytics.sharedInstance.setUserAttribute(segmentAnonymousID, withAttributeName: MoEngageDestinationConstant.segmentAnonymousIDAttribute, forAppID: appID)
            }
        }
        
        if UNUserNotificationCenter.current().delegate == nil {
            UNUserNotificationCenter.current().delegate = self
        }
    }
    
    public func identify(event: IdentifyEvent) -> IdentifyEvent? {
        guard let apiKey = moengageSettings?.apiKey else { return nil }

        if let userId = event.userId, !userId.isEmpty {
            MoEngageSDKAnalytics.sharedInstance.setUniqueID(userId, forAppID: apiKey)
        }

        if let segmentAnonymousID = self.analytics?.anonymousId {
            MoEngageSDKAnalytics.sharedInstance.setUserAttribute(segmentAnonymousID, withAttributeName: MoEngageDestinationConstant.segmentAnonymousIDAttribute, forAppID: apiKey)
        }

        if let traits = event.traits?.dictionaryValue {
            if let birthday = traits[UserAttributes.birthday.rawValue] as? NSNumber {
                let timeInterval = TimeInterval(birthday.doubleValue)
                let formattedBirthday = Date(timeIntervalSinceReferenceDate: timeInterval)
                MoEngageSDKAnalytics.sharedInstance.setDateOfBirth(formattedBirthday, forAppID: apiKey)
            }
            
            if let name = traits[UserAttributes.name.rawValue] as? String {
                MoEngageSDKAnalytics.sharedInstance.setName(name, forAppID: apiKey)
            }
            if let birthday = traits[UserAttributes.isoBirthday.rawValue] as? String {
                MoEngageSDKAnalytics.sharedInstance.setDateOfBirthInISO(birthday, forAppID: apiKey)
            }
            
            if let email = traits[UserAttributes.email.rawValue] as? String {
                MoEngageSDKAnalytics.sharedInstance.setEmailID(email, forAppID: apiKey)
            }
            
            if let firstName = traits[UserAttributes.firstName.rawValue] as? String {
                MoEngageSDKAnalytics.sharedInstance.setFirstName(firstName, forAppID: apiKey)
            }
            
            if let lastName = traits[UserAttributes.lastName.rawValue] as? String {
                MoEngageSDKAnalytics.sharedInstance.setLastName(lastName, forAppID: apiKey)
            }
            
            if let gender = (traits[UserAttributes.gender.rawValue] as? String)?.lowercased() {
                if gender == MoEngageDestinationConstant.m_male || gender == MoEngageDestinationConstant.male {
                    MoEngageSDKAnalytics.sharedInstance.setGender(.male, forAppID: apiKey)
                }
                else if gender == MoEngageDestinationConstant.f_female || gender == MoEngageDestinationConstant.female {
                    MoEngageSDKAnalytics.sharedInstance.setGender(.female, forAppID: apiKey)
                }
                else {
                    MoEngageSDKAnalytics.sharedInstance.setGender(.others, forAppID: apiKey)
                }
            }
            
            if let phone = traits[UserAttributes.phone.rawValue] as? String {
                MoEngageSDKAnalytics.sharedInstance.setMobileNumber(phone, forAppID: apiKey)
            }
            
            if let isoDate = traits[UserAttributes.isoDate.rawValue] as? [String: Any] {
                if let date = isoDate[MoEngageDestinationConstant.date] as? Date, let attributeName = isoDate[MoEngageDestinationConstant.attributeName] as? String {
                    MoEngageSDKAnalytics.sharedInstance.setUserAttributeDate(date, withAttributeName: attributeName, forAppID: apiKey)
                }
            }
            
            if let location = traits[UserAttributes.location.rawValue] as? [String: Any] {
                if let latitute = location[MoEngageDestinationConstant.latitude] as? Double, let longitude = location[MoEngageDestinationConstant.longitude] as? Double {
                    MoEngageSDKAnalytics.sharedInstance.setLocation(MoEngageGeoLocation(withLatitude: latitute, andLongitude: longitude), forAppID: apiKey)
                }
            }
            
            let moengageTraits = UserAttributes.allCases.map { $0.rawValue }
            
            for trait in traits where !moengageTraits.contains(trait.key) {
                switch trait.value {
                case let val as Date:
                    MoEngageSDKAnalytics.sharedInstance.setUserAttributeDate(val, withAttributeName: trait.key, forAppID: apiKey)
                default:
                    MoEngageSDKAnalytics.sharedInstance.setUserAttribute(trait.value, withAttributeName: trait.key, forAppID: apiKey)
                }
            }
        }
        
        return event
    }
    
    public func track(event: TrackEvent) -> TrackEvent? {
        guard let apiKey = moengageSettings?.apiKey else { return nil }
        
        if var generalAttributeDict = event.properties?.dictionaryValue {
            var dateAttributeDict: [String : Date] = [:]
            
            let keys = generalAttributeDict.keys
            for key in keys {
                let val = generalAttributeDict[key]
                if val is String {
                    if let converted_date = date(fromISOdateStr: val as? String) {
                        dateAttributeDict[key] = converted_date
                        generalAttributeDict.removeValue(forKey: key)
                    }
                }
            }
            let moeProperties = MoEngageProperties(withAttributes: generalAttributeDict)
            for key in dateAttributeDict.keys {
                if let dateVal = dateAttributeDict[key] {
                    moeProperties.addDateAttribute(dateVal, withName: key)
                }
            }
            MoEngageSDKAnalytics.sharedInstance.trackEvent(event.event, withProperties: moeProperties, forAppID: apiKey)
        }
        
        return event
    }
    
    func date(fromISOdateStr isoDateStr: String?) -> Date? {
        var dateFormatter: DateFormatter?
        if let isoDateStr {
            dateFormatter = MoEngageDateUtils.dateFormatterForUsPosixLocale(withFormat: "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'", forGMTTimeZone: true)
            return dateFormatter?.date(from: isoDateStr)
        }
        return nil
    }
    
    public func alias(event: AliasEvent) -> AliasEvent? {
        if let userId = event.userId, let apiKey = moengageSettings?.apiKey {
            MoEngageSDKAnalytics.sharedInstance.setAlias(userId, forAppID: apiKey)
        }
        return event
    }
    
    public func flush() {
        if let apiKey = moengageSettings?.apiKey {
            MoEngageSDKAnalytics.sharedInstance.flush(forAppID: apiKey)
        }
    }
    
    public func reset() {
        if let apiKey = moengageSettings?.apiKey {
            MoEngageSDKAnalytics.sharedInstance.resetUser(forAppID: apiKey) { [weak self] _ in
                if let segmentAnonymousID = self?.analytics?.anonymousId {
                    MoEngageSDKAnalytics.sharedInstance.setUserAttribute(segmentAnonymousID, withAttributeName: MoEngageDestinationConstant.segmentAnonymousIDAttribute, forAppID: apiKey)
                }
            }
        }
    }
}

// MARK: - Push Notification methods

extension MoEngageDestination: RemoteNotifications {
    public func registeredForRemoteNotifications(deviceToken: Data) {
        MoEngageSDKMessaging.sharedInstance.setPushToken(deviceToken)
    }
    
    public func failedToRegisterForRemoteNotification(error: Error?) {
        MoEngageSDKMessaging.sharedInstance.didFailToRegisterForPush()
    }
    
    public func receivedRemoteNotification(userInfo: [AnyHashable : Any]) {
        MoEngageSDKMessaging.sharedInstance.didReceieveNotification(withInfo: userInfo)
    }
}

// MARK: - User Notification Center delegate methods
extension MoEngageDestination: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert , .sound])
    }
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        MoEngageSDKMessaging.sharedInstance.userNotificationCenter(center, didReceive: response)
        completionHandler()
    }
}

struct MoEngageSettings: Codable {
    var apiKey: String
}

enum UserAttributes: String, CaseIterable {
    case userName
    case phone
    case gender
    case lastName
    case firstName
    case email
    case isoBirthday
    case isoDate
    case location
    case birthday
    case name
}
