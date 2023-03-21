## Front Finance iOS SDK

Let your users to connect a brokerage accounts via Front iOS SDK.

### Setup

Add `FrontLinkSDK.xcframework` to your project.

### Launch Catalog

Fetch a catalog link with Front API using your ClientID and API key

Connect brokerage account with `catalogLink` and receive result.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GetFrontLinkSDK.setup(catalogLink: "")
    }
}
```

### Store/Load connected accounts

`GetFrontLinkSDK.defaultBrokersManager` stores the connected brokerage account data in the keychain and allows to load it.
`GetFrontLinkSDK.defaultBrokersManager.brokers` is an actual array of connected brokerage accounts.

