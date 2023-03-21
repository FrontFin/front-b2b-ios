//
//  ViewController.swift
//  FrontLinkSDKTestApp
//
//  Created by Alexander on 3/13/23.
//

import UIKit
import FrontLinkSDK

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let vc = UIStoryboard(name: "AccountConnectionsViewController", bundle: .main).instantiateViewController(withIdentifier: "AccountConnectionsViewController") as? AccountConnectionsViewController else {
                fatalError("Unable to Instantiate AccountConnectionsViewController")
            }
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: false)
    }


}

