# BTNotificationEnabler

This tweak enables all iOS Notification Center bulletins to be sent to bluetooth devices implementing the Message Access Protocol. First implemented in iOS 6, MAP is a protocol that enables bluetooth devices to receive message notifications. This tweak allows devices like the [Pebble](http://getpebble.com) watch to receive all notifications that would normally appear on an iOS device’s lockscreen.

This tweak functions by eliminating the filter in Apple’s MAP implementation so that all notifications are considered ‘interesting’, not just Message notifications, and thus the name.

## License

BTNotificationEnabler is available under the MIT license. See the LICENSE file for more info.
