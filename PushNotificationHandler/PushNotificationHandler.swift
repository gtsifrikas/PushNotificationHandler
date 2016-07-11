//
//  PushNotificationHandler.swift
//
//  Created by George Tsifrikas on 16/06/16.
//  Copyright © 2016 George Tsifrikas. All rights reserved.
//

import Foundation

struct WeakContainer<T where T: AnyObject> {
    weak var _value : T?
    
    init (value: T) {
        _value = value
    }
    
    func get() -> T? {
        return _value
    }
}

class PushNotificationHandler {
    static let sharedInstance = PushNotificationHandler()
    private var subscribers: [WeakContainer<UIViewController>] = []
    private var apnsToken: String?
    
    private var newTokenHandler: (tokenData: NSData?, token: String?, error: NSError?) -> (Void) = {_,_,_ in}
    
    func alreadySubscribedIndex(potentialSubscriber: PushNotificationSubscriber) -> Int? {
        return subscribers.indexOf({ (weakSubscriber) -> Bool in
            if let validPotentialSubscriber = potentialSubscriber as? UIViewController, let validWeakSubscriber = weakSubscriber.get() {
                return unsafeAddressOf(validPotentialSubscriber).distanceTo(unsafeAddressOf(validWeakSubscriber)) == 0
            }
            return false
        })
    }
    
    func registerNewAPNSTokenHandler(handler: (tokenData: NSData?, token: String?, error: NSError?)->(Void)) {
        newTokenHandler = handler
    }
    
    func subscribeForPushNotifications<T where T: PushNotificationSubscriber>(subscriber: T)  {
        if let validSubscriber = subscriber as? UIViewController {
            if alreadySubscribedIndex(subscriber) == nil {
                subscribers += [WeakContainer(value: validSubscriber)]
            }
        }
    }
    
    func unsubscribeForPushNotifications<T where T: PushNotificationSubscriber>(subscriber: T)  {
        if let index = alreadySubscribedIndex(subscriber) {
            subscribers.removeAtIndex(index)
        }
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length { 
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        apnsToken = tokenString
        newTokenHandler(tokenData: deviceToken, token: tokenString, error: nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        newTokenHandler(tokenData: nil, token: nil, error: error)
        print("Failed to register:", error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        handleAPNS(aps)
    }
    
    func handleAPNS(aps: [String : AnyObject]) {
        for containerOfSubscriber in subscribers {
            (containerOfSubscriber.get() as? PushNotificationSubscriber)?.newPushNotificationReceived(aps)
        }
    }
    
    func handleApplicationStartWith(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        if let notification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
            if let aps = notification["aps"] as? [String: AnyObject] {
                handleAPNS(aps)
            }
        }
        
    }
}

protocol PushNotificationSubscriber {
    func newPushNotificationReceived(aps: [String: AnyObject])
}
