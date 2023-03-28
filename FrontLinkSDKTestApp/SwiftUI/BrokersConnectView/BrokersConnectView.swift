//
//  BrokersConnectView.swift
//  FrontLinkSDKTestApp
//
//  Created by Alexander on 3/27/23.
//

import SwiftUI
import Combine
import FrontLinkSDK

public struct BrokersConnectView: View {
    private let brokersManager: AddBrokersManaging

    private let onClose: () -> Void

    public var body: some View {
        _BrokersConnectView(brokersManager: brokersManager, onClose: onClose)
            .background(
                Color(red: 24 / 255, green: 24 / 255, blue: 29 / 255)
                    .ignoresSafeArea()
            )
    }

    public init(brokersManager: AddBrokersManaging, onClose: @escaping () -> Void) {
        self.brokersManager = brokersManager
        self.onClose = onClose
    }
}

fileprivate struct _BrokersConnectView: UIViewControllerRepresentable {
    var subscription = Set<AnyCancellable>()

    private var brokersManager: AddBrokersManaging?

    private var onClose: (() -> Void)?
    init(brokersManager: AddBrokersManaging? = nil, onClose: @escaping () -> Void) {
        self.brokersManager = brokersManager ?? GetFrontLinkSDK.defaultBrokersManager
        self.onClose = onClose
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<_BrokersConnectView>) -> UIViewController {
        let brokerConnectViewController = GetFrontLinkSDK.brokerConnectWebViewController(brokersManager: brokersManager, delegate: self)
        let nav = UINavigationController(rootViewController: brokerConnectViewController)
        nav.modalPresentationStyle = .fullScreen
        return nav
    }

     func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

extension _BrokersConnectView: BrokerConnectViewControllerDelegate {
    func setBrokerConnectViewController(_ viewController: UIViewController) {}
    
    func accountsConnected(_ accounts: [FrontLinkSDK.BrokerAccountable]) {
        print(accounts)
    }
    
    func closeViewController() {
        onClose?()
    }
}
