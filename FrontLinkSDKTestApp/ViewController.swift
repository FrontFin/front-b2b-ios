//
//  ViewController.swift
//  FrontLinkSDKTestApp
//
//  Created by Alexander on 3/13/23.
//

import UIKit
import FrontLinkSDK
import SwiftUI

class ViewController: UIViewController {
    private var brokersManager = GetFrontLinkSDK.defaultBrokersManager

    @IBAction func swiftUIFlow(_ sender: Any) {
        let viewModel = AccountConnectionsViewModel(brokersManager: brokersManager)
        let rootView = AccountConnectionsView(viewModel: viewModel)
        let vc = UIHostingController(rootView: rootView)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    @IBAction func uiKitFlow(_ sender: Any) {
        guard let vc = UIStoryboard(name: "AccountConnectionsViewController", bundle: .main).instantiateViewController(withIdentifier: "AccountConnectionsViewController") as? AccountConnectionsViewController else {
                fatalError("Unable to Instantiate AccountConnectionsViewController")
            }

        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
    }

}

