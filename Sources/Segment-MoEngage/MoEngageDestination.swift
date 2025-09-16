import Segment
import MoEngageSDK
import UIKit

@objc(MoEngageDestination)
public class MoEngageDestination: UIResponder, DestinationPlugin, MoEngagePartnerIntegrationHandler.Integrator {
    public let timeline = Timeline()
    public let type = PluginType.destination
    public let key = MoEngageDestinationConstant.destinationKey
    
    public var analytics: Analytics?
    private var moengageSettings: MoEngageSettings?
    private let handler = MoEngagePartnerIntegrationHandler(type: .segment)

    public override init() {
    }
    
    public func update(settings: Settings, type: UpdateType) {
        guard
          let tempSettings: MoEngageSettings = settings.integrationSettings(forPlugin: self),
          moengageSettings?.apiKey != tempSettings.apiKey, // allow update only if workspace id has changed
          case let workspaceId = tempSettings.apiKey
        else {
            MoEngageLogger.logDefault(logLevel: .debug, message: "Skipped SDK enablement for \(String(describing: settings.integrations?.dictionaryValue))")
            return
        }

        MoEngageLogger.logDefault(logLevel: .debug, message: "Enabling MoEngage SDK for \(workspaceId)")
        moengageSettings = tempSettings
        MoEngageCoreIntegrator.sharedInstance.enableSDKForPartner(workspaceId: workspaceId, integrationType: .segment)
        self.enabled(forWorkspaceId: workspaceId)
    }

    public func enabled(forWorkspaceId workspaceId: String) {
        DispatchQueue.main.async {
            if let segmentAnonymousID = self.analytics?.anonymousId {
                MoEngageSDKAnalytics.sharedInstance.setUserAttribute(segmentAnonymousID, withAttributeName: MoEngageDestinationConstant.segmentAnonymousIDAttribute, forAppID: workspaceId)
            }
        }
    }

    public func identify(event: IdentifyEvent) -> IdentifyEvent? {
        var actions: [(String) -> Void] = []
        if let userId = event.userId, !userId.isEmpty {
            actions.append { MoEngageSDKAnalytics.sharedInstance.identifyUser(identity: userId, workspaceId: $0) }
        }

        if let segmentAnonymousID = self.analytics?.anonymousId {
            actions.append {
                MoEngageSDKAnalytics.sharedInstance.setUserAttribute(
                    segmentAnonymousID, withAttributeName: MoEngageDestinationConstant.segmentAnonymousIDAttribute,
                    forAppID: $0
                )
            }
        }

        if var traits = event.traits?.dictionaryValue {
            if let birthday = traits[UserAttributes.birthday.rawValue] as? NSNumber {
                let timeInterval = TimeInterval(birthday.doubleValue)
                let formattedBirthday = Date(timeIntervalSinceReferenceDate: timeInterval)
                actions.append { MoEngageSDKAnalytics.sharedInstance.setDateOfBirth(formattedBirthday, forAppID: $0) }
                traits.removeValue(forKey: UserAttributes.birthday.rawValue)
            } else if let birthday = traits[UserAttributes.birthday.rawValue] as? Date {
                actions.append { MoEngageSDKAnalytics.sharedInstance.setDateOfBirth(birthday, forAppID: $0) }
                traits.removeValue(forKey: UserAttributes.birthday.rawValue)
            } else if let birthdayStr = traits[UserAttributes.birthday.rawValue] as? String, let birthday = self.date(fromISOdateStr: birthdayStr) {
                actions.append { MoEngageSDKAnalytics.sharedInstance.setDateOfBirth(birthday, forAppID: $0) }
                traits.removeValue(forKey: UserAttributes.birthday.rawValue)
            }

            if let name = traits[UserAttributes.name.rawValue] as? String {
                actions.append { MoEngageSDKAnalytics.sharedInstance.setName(name, forAppID: $0) }
                traits.removeValue(forKey: UserAttributes.name.rawValue)
            }
            if let birthday = traits[UserAttributes.isoBirthday.rawValue] as? String {
                actions.append { MoEngageSDKAnalytics.sharedInstance.setDateOfBirthInISO(birthday, forAppID: $0) }
                traits.removeValue(forKey: UserAttributes.isoBirthday.rawValue)
            }
            
            if let email = traits[UserAttributes.email.rawValue] as? String {
                actions.append { MoEngageSDKAnalytics.sharedInstance.setEmailID(email, forAppID: $0) }
                traits.removeValue(forKey: UserAttributes.email.rawValue)
            }
            
            if let firstName = traits[UserAttributes.firstName.rawValue] as? String {
                actions.append { MoEngageSDKAnalytics.sharedInstance.setFirstName(firstName, forAppID: $0) }
                traits.removeValue(forKey: UserAttributes.firstName.rawValue)
            }
            
            if let lastName = traits[UserAttributes.lastName.rawValue] as? String {
                actions.append { MoEngageSDKAnalytics.sharedInstance.setLastName(lastName, forAppID: $0) }
                traits.removeValue(forKey: UserAttributes.lastName.rawValue)
            }
            
            if let gender = (traits[UserAttributes.gender.rawValue] as? String)?.lowercased() {
                if gender == MoEngageDestinationConstant.m_male || gender == MoEngageDestinationConstant.male {
                    actions.append { MoEngageSDKAnalytics.sharedInstance.setGender(.male, forAppID: $0) }
                }
                else if gender == MoEngageDestinationConstant.f_female || gender == MoEngageDestinationConstant.female {
                    actions.append { MoEngageSDKAnalytics.sharedInstance.setGender(.female, forAppID: $0) }
                }
                else {
                    actions.append { MoEngageSDKAnalytics.sharedInstance.setGender(.others, forAppID: $0) }
                }
                traits.removeValue(forKey: UserAttributes.gender.rawValue)
            }
            
            if let phone = traits[UserAttributes.phone.rawValue] as? String {
                actions.append { MoEngageSDKAnalytics.sharedInstance.setMobileNumber(phone, forAppID: $0) }
                traits.removeValue(forKey: UserAttributes.phone.rawValue)
            }
            
            if let isoDate = traits[UserAttributes.isoDate.rawValue] as? [String: Any] {
                if let date = isoDate[MoEngageDestinationConstant.date] as? Date, let attributeName = isoDate[MoEngageDestinationConstant.attributeName] as? String {
                    actions.append { MoEngageSDKAnalytics.sharedInstance.setUserAttributeDate(date, withAttributeName: attributeName, forAppID: $0) }
                    traits.removeValue(forKey: UserAttributes.isoDate.rawValue)
                }
            }
            
            if let location = traits[UserAttributes.location.rawValue] as? [String: Any] {
                if let latitute = location[MoEngageDestinationConstant.latitude] as? Double, let longitude = location[MoEngageDestinationConstant.longitude] as? Double {
                    actions.append { MoEngageSDKAnalytics.sharedInstance.setLocation(MoEngageGeoLocation(withLatitude: latitute, andLongitude: longitude), forAppID: $0) }
                    traits.removeValue(forKey: UserAttributes.location.rawValue)
                }
            }
            
            for trait in traits {
                switch trait.value {
                case let val as Date:
                    actions.append { MoEngageSDKAnalytics.sharedInstance.setUserAttributeDate(val, withAttributeName: trait.key, forAppID: $0) }
                case let val as String:
                    guard let date = self.date(fromISOdateStr: val) else { fallthrough }
                    actions.append { MoEngageSDKAnalytics.sharedInstance.setUserAttributeDate(date, withAttributeName: trait.key, forAppID: $0) }
                default:
                    actions.append { MoEngageSDKAnalytics.sharedInstance.setUserAttribute(trait.value, withAttributeName: trait.key, forAppID: $0) }
                }
            }
        }

        handler.process(integrator: self, forWorkspaceId: moengageSettings?.apiKey) { workspaceId in
            for action in actions {
                action(workspaceId)
            }
        }
        return event
    }
    
    public func track(event: TrackEvent) -> TrackEvent? {
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
            handler.process(integrator: self, forWorkspaceId: moengageSettings?.apiKey) { workspaceId in
                MoEngageSDKAnalytics.sharedInstance.trackEvent(
                    event.event, withProperties: moeProperties, forAppID: workspaceId
                )
            }
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
        if let userId = event.userId {
            handler.process(integrator: self, forWorkspaceId: moengageSettings?.apiKey) { workspaceId in
                MoEngageSDKAnalytics.sharedInstance.identifyUser(identity: userId, workspaceId: workspaceId)
            }
        }
        return event
    }
    
    public func flush() {
        handler.process(integrator: self, forWorkspaceId: moengageSettings?.apiKey) { workspaceId in
            MoEngageSDKAnalytics.sharedInstance.flush(forAppID: workspaceId)
        }
    }
    
    public func reset() {
        handler.process(integrator: self, forWorkspaceId: moengageSettings?.apiKey) { workspaceId in
            MoEngageSDKAnalytics.sharedInstance.resetUser(forAppID: workspaceId) { [weak self] _ in
                self?.enabled(forWorkspaceId: workspaceId)
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
