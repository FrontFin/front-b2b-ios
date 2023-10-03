//
//  ViewController.swift
//  FrontLinkSDKTestApp
//
//  Created by Alexander on 3/13/23.
//

import UIKit
import FrontLinkSDK
import SwiftUI

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var linkTokenTextField: UITextField!
    @IBOutlet var swiftUIButton: UIButton!
    @IBOutlet var uiKitButton: UIButton!

    private var brokersManager = GetFrontLinkSDK.defaultBrokersManager

    override func viewDidLoad() {
        linkTokenTextField.delegate = self
        [swiftUIButton, uiKitButton].forEach(){ button in
            guard let button = button else { return }
            button.layer.borderColor = Color.black.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = button.bounds.size.height * 0.5
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        GetFrontLinkSDK.setup(linkToken: linkTokenTextField.text)
        guard GetFrontLinkSDK.isSetUp else {
            swiftUIButton.isEnabled = false
            uiKitButton.isEnabled = false
            return false
        }
        swiftUIButton.isEnabled = true
        uiKitButton.isEnabled = true
        linkTokenTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func swiftUIFlow(_ sender: Any) {
        if GetFrontLinkSDK.isTransferLink {
            let vc = UIHostingController(rootView: CryptoTransferView())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else {
            let viewModel = AccountConnectionsViewModel(brokersManager: brokersManager) {
                self.dismiss(animated: true)
            }
            let accountConnectionsView = AccountConnectionsView(viewModel: viewModel)
            let vc = UIHostingController(rootView: accountConnectionsView)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        linkTokenTextField.text = nil
    }

    @IBAction func uiKitFlow(_ sender: Any) {
        let accountConnectionsViewControllerClassName = String(describing: AccountConnectionsViewController.self)
        let cryptoTransferViewControllerClassName = String(describing: CryptoTransferViewController.self)
        let vcIdentifier = GetFrontLinkSDK.isTransferLink ? cryptoTransferViewControllerClassName : accountConnectionsViewControllerClassName
        let vc = UIStoryboard(name: vcIdentifier, bundle: .main).instantiateViewController(withIdentifier: vcIdentifier)
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
        linkTokenTextField.text = nil
    }

}

