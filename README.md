## Front Finance iOS SDK

Let your users to connect a brokerage accounts via Front iOS SDK.

### Setup

Add package dependency `FrontLinkSDKPackage` https://github.com/FrontFin/front-b2b-ios-sdk
or download `FrontLinkSDK.xcframework` from the latest release https://github.com/FrontFin/front-b2b-ios-sdk/releases and add to your project manually.

### Launch Catalog

The app should use a proprietary API that fetches a `catalogLink` with Front API using your ClientID and API key for each brokerage account connection session.

Set up `GetFrontLinkSDK` with the `catalogLink`

```swift
        let catalogLink = ...
        GetFrontLinkSDK.setup(catalogLink: catalogLink)
```

Crreate and present a view controller for brokerage account connection

```swift
    brokerConnectViewController = GetFrontLinkSDK.brokerConnectWebViewController(brokersManager: brokersManager, delegate: self)
    present(brokerConnectViewController, animated: true)
```

or use a convenience method

```swift
    GetFrontLinkSDK.connectBrokers(in: self, delegate: self)
```

Implement a delegate class that conforms to `BrokerConnectViewControllerDelegate` protocol.

If you use `GetFrontLinkSDK.connectBrokers()`, implement the following delegate function to store a reference to the view controller

```swift
    var brokerConnectViewController: UIViewController?

    func setBrokerConnectViewController(_ viewController: UIViewController) {
        brokerConnectViewController = viewController
    }
```

Implement this function to handle a brokerage account(s) connection.
Some brokerage companies allow to have subaccounts, in case you connect an account with multiple subaccounts `accounts` parameter keeps an array of accounts.

```swift
    func accountsConnected(_ accounts: [FrontLinkSDK.BrokerAccountable]) {
        ...
    }
```

Implement the following function to discard `brokerConnectViewController` depending on how you created it

```swift
    func closeViewController(withConfirmation: Bool) {
        let onClose = {
            brokerConnectViewController?.dismiss(animated: true)
        }
        guard withConfirmation else {
            onClose()
            return
        }
        let alert = UIAlertController(title: ..., message: ..., preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            onClose()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        brokerConnectViewController?.present(alert, animated: true)
    }
```

Implement the following functions if you'd like to indicate a progress of content loading. You can keep default loading animation or replace it with your custom one.

```swift
    func showProgress() {
        brokerConnectViewController?.showFrontLoader()
    }
    
    func hideProgress() {
        brokerConnectViewController?.removeFrontLoader()
    }
```

### Store/Load connected accounts

`GetFrontLinkSDK.defaultBrokersManager` stores the connected brokerage account data in the keychain and allows to load it.
`GetFrontLinkSDK.defaultBrokersManager.brokers` is an actual array of connected brokerage accounts.

