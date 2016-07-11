#
# Be sure to run `pod lib lint PushNotificationHandler.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PushNotificationHandler'
  s.version          = '0.1.0'
  s.summary          = 'A simple library to register(optioanl) and handle push notifications in your app.'

  s.description      = <<-DESC
                        With this library you can register your app for push notifications and get the notification token without any hassle in order to send it to your Push Notification Service (your backend server for example). Also provides a subscription based model that any UIViewController can subscribe and get PushNotifications.
                       DESC

  s.homepage         = 'https://github.com/gtsif21/PushNotificationHandler'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'George Tsifrikas' => 'gtsifrikas@gmail.com' }
  s.source           = { :git => 'https://github.com/gtsif21/PushNotificationHandler.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/gtsifrikas'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PushNotificationHandler/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
