# LitalAds

[![CI Status](https://img.shields.io/travis/precisef0x/LitalAds.svg?style=flat)](https://travis-ci.org/precisef0x/LitalAds)
[![Version](https://img.shields.io/cocoapods/v/LitalAds.svg?style=flat)](https://cocoapods.org/pods/LitalAds)
[![License](https://img.shields.io/cocoapods/l/LitalAds.svg?style=flat)](https://cocoapods.org/pods/LitalAds)
[![Platform](https://img.shields.io/cocoapods/p/LitalAds.svg?style=flat)](https://cocoapods.org/pods/LitalAds)

## Installation

LitalAds is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LitalAds'
```

Also, for iOS 9 you have to add app schema your app will use and check for `canOpenURL(:)`.

Add this to your Info.plist:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>lital</string>
</array>
```

## Usage

To initialize pod add:

```swift
LitalAds.shared.initialize()
```

to `applicationDidBecomeActive(:)` method in your AppDelegate.
  
To show an ad call  `LitalAds.shared.showAd()` anywhere in your code.

## Author

Ilia Kambarov, me@f0x.pw

## License

LitalAds is available under the MIT license. See the LICENSE file for more info.
# LitalAds
