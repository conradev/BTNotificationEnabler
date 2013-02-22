# BTNotificationEnabler

This tweak enables all iOS Notification Center bulletins to be sent to bluetooth devices implementing the Message Access Protocol. First implemented in iOS 6, MAP is a protocol that enables bluetooth devices to receive message notifications. This tweak allows devices like the [Pebble](http://getpebble.com) watch to receive all notifications that would normally appear on an iOS device’s lockscreen.

This tweak functions by eliminating the filter in Apple’s MAP implementation so that all notifications are considered ‘interesting’, not just Message notifications, and thus the name.

## Getting Started

### Prequisites

- [Xcode 4.6](https://itunes.apple.com/us/app/xcode/id497799835), which includes the iOS 6.1 SDK
- A jailbroken device running iOS 6 or later

### Building

The first step to build the project is to clone the repository and initialize all of its submodules:

``` sh
git clone git://github.com/conradev/BTNotificationEnabler.git
cd BTNotificationEnabler
git submodule update --init
```

To build the project, you need only run

```
make
```

### Installing

To install this on a jailbroken device, some additional tools are needed.

The first tool is `ldid`, which is used for fakesigning binaries. Ryan Petrich has a build on his [Github mirror](https://github.com/rpetrich/ldid):

``` sh
curl -O http://cloud.github.com/downloads/rpetrich/ldid/ldid.zip
unzip ldid.zip
mv ldid theos/bin/
rm ldid.zip
```

To build a Debian package, `dpkg` is required. You can install it from [Homebrew](http://mxcl.github.com/homebrew/):

``` sh
brew install dpkg
```

To build a package in the project directory, you can run:

``` sh
make package
```

and to automatically install this package on your jailbroken device (over SSH), you can run:

``` sh
make package install THEOS_DEVICE_IP=xxx.xxx.xxx.xxx
```

## License

BTNotificationEnabler is available under the MIT license. See the LICENSE file for more info.
