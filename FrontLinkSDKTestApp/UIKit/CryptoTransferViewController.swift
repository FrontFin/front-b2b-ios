//
//  CryptoTransferViewController.swift
//  FrontLinkSDKTestApp
//
//  Created by Alexander on 5/31/23.
//

import UIKit
import FrontLinkSDK

class CryptoTransferViewController: UIViewController {

    private var brokersManager = GetFrontLinkSDK.defaultBrokersManager
    internal var brokerConnectViewController: UIViewController?

    @IBAction func connectDestAcc(_ sender: Any) {
        guard GetFrontLinkSDK.isSetUp else {
            fatalError("FrontLinkSDK is not set up properly")
        }
        brokerConnectViewController = GetFrontLinkSDK.brokerConnectWebViewController(brokersManager: brokersManager, delegate: self)
        guard let brokerConnectViewController else { return }
        
        present(brokerConnectViewController, animated: true)
    }
}

extension CryptoTransferViewController: BrokerConnectViewControllerDelegate {
    func setBrokerConnectViewController(_ viewController: UIViewController) {
    }
    
    func accountsConnected(_ accounts: [FrontLinkSDK.BrokerAccountable]) {
        print(accounts)
    }
    
    func transferFinished(_ transfer: FrontLinkSDK.TransferFinished) {
        guard let brokerConnectViewController else { return }
        var message: String
        var title: String
        switch transfer.status {
        case .transferFinishedSuccess:
            title = "Transfer finished"
            message = "Transfer ID:\(transfer.txId ?? "")\nnetworkId: \(transfer.networkId ?? "")\nAmount:\(transfer.amount ?? 0)\nSymbol:\(transfer.symbol ?? "")"
        case .transferFinishedError:
            title = "Transfer failed"
            message = transfer.errorMessage ?? ""
        @unknown default:
            title = "Transfer finished"
            message = "Unexpected status"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let messageText = NSAttributedString(
            string: message,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor : UIColor.darkGray,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)
            ]
        )
        alert.setValue(messageText, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        brokerConnectViewController.present(alert, animated: true)
    }
    
    func closeViewController(withConfirmation: Bool) {
        let onClose = {
            self.brokerConnectViewController?.dismiss(animated: true) {
                self.navigationController?.dismiss(animated: true)
            }
        }
        guard let brokerConnectViewController, withConfirmation else {
            onClose()
            return
        }
        let alert = UIAlertController(title: "Are you sure you want to exit?", message: "Your progress will be lost.", preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = .light
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            onClose()
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
