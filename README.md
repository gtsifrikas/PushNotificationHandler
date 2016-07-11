# PushNotificationHandler

[![Version](https://img.shields.io/cocoapods/v/PushNotificationHandler.svg?style=flat)](http://cocoapods.org/pods/PushNotificationHandler)
[![License](https://img.shields.io/cocoapods/l/PushNotificationHandler.svg?style=flat)](http://cocoapods.org/pods/PushNotificationHandler)
[![Platform](https://img.shields.io/cocoapods/p/PushNotificationHandler.svg?style=flat)](http://cocoapods.org/pods/PushNotificationHandler)

## Features

- [x] Register your app for push notifications
- [x] Subcribe your UIViewController(s) for new push notifications

## Communication
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

PushNotificationHandler is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PushNotificationHandler"
```
Then, run the following command:

```bash
$ pod install
```
## Usage
### Registering your app for push notifications
In your AppDelegate.swift file
```swift
import PushNotificationHandler
```

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    PushNotificationHandler.sharedInstance.registerForPushNotifications(application)
    PushNotificationHandler.sharedInstance.handleApplicationStartWith(application, launchOptions: launchOptions)

    PushNotificationHandler.sharedInstance.registerNewAPNSTokenHandler { (tokenData, token, error) -> (Void) in
        if let validToken = token {
            print("Device Token:", validToken)
        } else {
            print("Device token error: " + (error?.description ?? "Strange things are happening"))
        }
    }
}

```

Also implement the methods as following

```swift 
func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    PushNotificationHandler.sharedInstance.application(application, didReceiveRemoteNotification: userInfo)
}
```
```swift 
func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    PushNotificationHandler.sharedInstance.application(application, didRegisterUserNotificationSettings: notificationSettings)
}
```
```swift 
func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    PushNotificationHandler.sharedInstance.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
}
```
```swift 
func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    PushNotificationHandler.sharedInstance.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
}
```

### Subscribe a UIViewController for push notifications
In your UIViewController file

```swift
import PushNotificationHandler
```

Your controller must implement `PushNotificationSubscriber` protocol

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    PushNotificationHandler.sharedInstance.subscribeForPushNotifications(self)
}
```

```swift
deinit {
    PushNotificationHandler.sharedInstance.unsubscribeForPushNotifications(self)
}
```

```swift
func newPushNotificationReceived(aps: [String : AnyObject]) {
//do something with the push notification
}
```

That's it!



## Author

George Tsifrikas

PushNotificationHandler is available under the MIT license. See the LICENSE file for more info.
