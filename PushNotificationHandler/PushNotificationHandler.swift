//
//  PushNotificationHandler.swift
//
//  Created by George Tsifrikas on 16/06/16.
//  Copyright © 2016 George Tsifrikas. All rights reserved.
//

import Foundation

struct WeakContainer<T: AnyObject> {
    weak var _value : T?
    
    init (value: T) {
        _value = value
    }
    
    func get() -> T? {
        return _value
    }
}

public class PushNotificationHandler {
    public static let sharedInstance = PushNotificationHandler()
    private var subscribers: [WeakContainer<UIViewController>] = []
    private var apnsToken: String?
    
    public typealias NewTokenHandlerArguments = (tokenData: Data?, token: String?, error: Error?)
    private var newTokenHandler: (NewTokenHandlerArguments) -> Void = {_,_,_ in}
    
    private func alreadySubscribedIndex(potentialSubscriber: PushNotificationSubscriber) -> Int? {
        return subscribers.index(where: { (weakSubscriber) -> Bool in
            guard let validPotentialSubscriber = potentialSubscriber as? UIViewController,
                let validWeakSubscriber = weakSubscriber.get() else {
                    return false
            }
            
            return validPotentialSubscriber === validWeakSubscriber
        })
    }
    
    public func registerNewAPNSTokenHandler(handler: @escaping (NewTokenHandlerArguments) -> Void) {
        newTokenHandler = handler
    }
    
    public func subscribeForPushNotifications<T: PushNotificationSubscriber>(subscriber: T)  {
        if let validSubscriber = subscriber as? UIViewController {
            if alreadySubscribedIndex(potentialSubscriber: subscriber) == nil {
                subscribers += [WeakContainer(value: validSubscriber)]
            }
        }
    }
    
    public func unsubscribeForPushNotifications<T: PushNotificationSubscriber>(subscriber: T)  {
        if let index = alreadySubscribedIndex(potentialSubscriber: subscriber) {
            subscribers.remove(at: index)
        }
    }
    
    public func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenString = deviceToken.map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
        
        apnsToken = tokenString
        newTokenHandler((tokenData: deviceToken, token: tokenString, error: nil))
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        newTokenHandler((tokenData: nil, token: nil, error: error))
        print("Failed to register:", error)
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let aps = userInfo["aps"]
        handleAPNS(aps: aps as! [AnyHashable : Any])
    }
    
    private func handleAPNS(aps: [AnyHashable : Any]) {
        for containerOfSubscriber in subscribers {
            (containerOfSubscriber.get() as? PushNotificationSubscriber)?.newPushNotificationReceived(aps: aps)
        }
    }
    
    public func handleApplicationStartWith(application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey : Any]?) {
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            if let aps = notification["aps"] as? [String: AnyObject] {
                handleAPNS(aps: aps)
            }
        }
        
    }
}

public protocol PushNotificationSubscriber {
    func newPushNotificationReceived(aps: [AnyHashable : Any])
}
