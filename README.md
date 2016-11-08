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
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    PushNotificationHandler.sharedInstance.registerForPushNotifications(application: application)
    PushNotificationHandler.sharedInstance.handleApplicationStartWith(application: application, launchOptions: launchOptions)
        
    PushNotificationHandler.sharedInstance.registerNewAPNSTokenHandler { (tokenData, token, error) -> (Void) in
        if let validToken = token {
            print("Device Token:", validToken)
        } else {
            print("Device token error: " + (error?.localizedDescription ?? "Strange things are happening"))
        }
    }
}

```

Also implement the methods as following

```swift 
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    PushNotificationHandler.sharedInstance.application(application, didReceiveRemoteNotification: userInfo)
}
```
```swift 
func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    PushNotificationHandler.sharedInstance.application(application, didRegister: notificationSettings)
}

```
```swift 
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    PushNotificationHandler.sharedInstance.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
}
```
```swift 
func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
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
    PushNotificationHandler.sharedInstance.subscribeForPushNotifications(subscriber: self)
}
```

```swift
deinit {
    PushNotificationHandler.sharedInstance.unsubscribeForPushNotifications(subscriber: self)
}
```

```swift
func newPushNotificationReceived(aps: [AnyHashable : Any]) {
    // Do something with the push notification
}
```

That's it!



## Author

George Tsifrikas

PushNotificationHandler is available under the MIT license. See the LICENSE file for more info.
