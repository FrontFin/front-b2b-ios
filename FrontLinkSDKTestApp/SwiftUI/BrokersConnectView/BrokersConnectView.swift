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
        nav.setNavigationBarHidden(true, animated: false)
        nav.modalPresentationStyle = .fullScreen
        return nav
    }

     func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

var brokerConnectViewController: UIViewController?

extension _BrokersConnectView: BrokerConnectViewControllerDelegate {
    
    func setBrokerConnectViewController(_ viewController: UIViewController) {
        brokerConnectViewController = viewController
    }
    
    func accountsConnected(_ accounts: [FrontLinkSDK.BrokerAccountable]) {
        print(accounts)
    }
    
    func transferFinished(_ transfer: FrontLinkSDK.TransferFinished) {
        guard let brokerConnectViewController else { return }
        var message: String
        switch transfer.status {
        case .transferFinishedSuccess:
            message = "Transfer ID:\(transfer.txId ?? "")\nnetworkId: \(transfer.networkId ?? "")\nAmount:\(transfer.amount ?? 0)\nSymbol:\(transfer.symbol ?? "")"
        case .transferFinishedError:
            message = "Transfer failed: \(transfer.errorMessage ?? "")"
        }
        UIAlertController.presentAlert(title: "Transfer Finished", message: message, alignment: .left, presenter: brokerConnectViewController)
    }
    
    func closeViewController(withConfirmation: Bool) {
        guard let brokerConnectViewController, withConfirmation else {
            onClose?()
            return
        }
        let alert = UIAlertController(title: "Are you sure you want to exit?", message: "Your progress will be lost.", preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = .light
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            onClose?()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        brokerConnectViewController.present(alert, animated: true)
    }
    
    func showProgress() {
        brokerConnectViewController?.showFrontLoader()
    }
    
    func hideProgress() {
        brokerConnectViewController?.removeFrontLoader()
    }
    
}
