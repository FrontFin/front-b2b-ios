# Front Finance iOS SDK

Let your users to connect a brokerage accounts and execute crypto transfers via Front iOS SDK.

### 📌 Deprecation Notice

As of Dec 7, 2023 this package is no longer maintained and has been superseded by a new version. For the latest features, improvements, and bug fixes, please use our updated package: [mesh-ios-sdk](https://github.com/FrontFin/mesh-ios-sdk).

We encourage all users to migrate to the new package for continued support and updates.

## Setup

Add package dependency `FrontLinkSDKPackage` https://github.com/FrontFin/front-b2b-ios-sdk
or download `FrontLinkSDK.xcframework` from the latest release https://github.com/FrontFin/front-b2b-ios-sdk/releases and add to your project manually.

## Launch Catalog

The app should use a proprietary API that fetches a `linkToken` with Mesh API using your Client-ID and Client-Secret for each brokerage account connection or crypto transfer session.
Get Link token API: https://docs.meshconnect.com/reference/post_api-v1-linktoken

Set up `GetFrontLinkSDK` with the `linkToken`

```swift
        let linkToken = ...
        GetFrontLinkSDK.setup(linkToken: linkToken)
```

## UIKit

### Crreate and present a view controller for brokerage account connection

```swift
    brokerConnectViewController = GetFrontLinkSDK.brokerConnectWebViewController(brokersManager: brokersManager, delegate: self)
    present(brokerConnectViewController, animated: true)
```

or use a convenience method

```swift
    GetFrontLinkSDK.connectBrokers(in: self, delegate: self)
```

## SwiftUI 

### Implement BrokersConnectView

```swift
    public struct BrokersConnectView: View {
        private let brokersManager: AddBrokersManaging
        private let onClose: () -> Void
        public var body: some View {
            _BrokersConnectView(brokersManager: brokersManager, onClose: onClose)
        }
    }
```

### Implement a UIViewControllerRepresentable descendant

```swift
    struct _BrokersConnectView: UIViewControllerRepresentable {

        func makeUIViewController(context: UIViewControllerRepresentableContext<_BrokersConnectView>) -> UIViewController {
            let brokerConnectViewController = GetFrontLinkSDK.brokerConnectWebViewController(brokersManager: brokersManager, delegate: self)
            let nav = UINavigationController(rootViewController: brokerConnectViewController)
            nav.setNavigationBarHidden(true, animated: false)
            nav.modalPresentationStyle = .fullScreen
            return nav
        }
    }
```

### Present BrokersConnectView in your root view

```swift
    ...
    .sheet(isPresented: $showingConnectBrokers, content: {
        BrokersConnectView(brokersManager: GetFrontLinkSDK.defaultBrokersManager) {
            showingConnectBrokers = false
            viewModel.getAccounts()
        }
    })
```

## Implement a delegate class that conforms to `BrokerConnectViewControllerDelegate` protocol.

### For SwiftUI implement an extension that conforms to BrokerConnectViewControllerDelegate

```swift
    extension _BrokersConnectView: BrokerConnectViewControllerDelegate {
        ...
    }
```

### If you use `GetFrontLinkSDK.connectBrokers()`, implement the following delegate function to store a reference to the view controller

```swift
    var brokerConnectViewController: UIViewController?

    func setBrokerConnectViewController(_ viewController: UIViewController) {
        brokerConnectViewController = viewController
    }
```

### Implement this function to handle a brokerage account(s) connection.

Some brokerage companies allow to have subaccounts, in case you connect an account with multiple subaccounts `accounts` parameter keeps an array of accounts.

```swift
    func accountsConnected(_ accounts: [FrontLinkSDK.BrokerAccountable]) {
        ...
    }
```

### Implement this function to handle crypto transfers.

For crypto transfers you need to get link token with `transferOptions` body parameter, see https://docs.meshconnect.com/reference/post_api-v1-linktoken for reference

```swift
    func transferFinished(_ transfer: FrontLinkSDK.TransferFinished) {
        switch transfer.status {
        case .transferFinishedSuccess:
            ...
        case .transferFinishedError:
            ...
        }
    }
```

### Implement the following function to discard `brokerConnectViewController` depending on how you created it

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

### Implement the following functions if you'd like to indicate a progress of content loading. You can keep default loading animation or replace it with your custom one.

```swift
    func showProgress() {
        brokerConnectViewController?.showFrontLoader()
    }
    
    func hideProgress() {
        brokerConnectViewController?.removeFrontLoader()
    }
```

## Store/Load connected accounts

`GetFrontLinkSDK.defaultBrokersManager` stores the connected brokerage account data in the keychain and allows to load it.
`GetFrontLinkSDK.defaultBrokersManager.brokers` is an actual array of connected brokerage accounts.

## Delete account

In order to delete a connected brokerage account, the [Remove connection API]https://docs.meshconnect.com/reference/delete_api-v1-account must be called, then the account can be deleted in iOS SDK

```swift
    let broker = brokersManager.brokers[index]
    brokersManager.remove(broker: broker)
```
