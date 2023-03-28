//
//  AccountConnectionsViewController.swift
//  FrontSDKTestApp
//
//  Created by Alex Bibikov on 19.10.2022.
//

import SwiftUI
import FrontLinkSDK

class AccountConnectionCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "AccountConnectionCollectionViewCell"

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var accountNameLabel: UILabel!
    @IBOutlet private weak var accountIDLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!

    func setup(broker: BrokerAccountable) {
        iconImageView.image = broker.icon
        accountIDLabel.text = broker.accountId
        accountNameLabel.text = broker.accountName
        nameLabel.text = broker.brokerName
    }
}

class AccountConnectionsViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!

    // You can implement your own manager. Just inherit the `AddBrokersManaging` protocol for your entity.
    private var brokersManager = GetFrontLinkSDK.defaultBrokersManager
    internal var brokerConnectViewController: UIViewController?
    private var brokers: [BrokerAccountable] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private let presentBrokerConnectViewControllerModally = true

    override func viewDidLoad() {
        super.viewDidLoad()

        brokerListUpdated()
        NotificationCenter.default.addObserver(self, selector: #selector(brokerListUpdated), name: .brokerListUpdated, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        var items: [UIBarButtonItem] = []
        
        items.append(UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(connectBrokers)))
        navigationItem.rightBarButtonItems = items
    }

    @objc private func connectBrokers() {
        guard let catalogLink = GetFrontLinkSDK.catalogLink, !catalogLink.isEmpty else {
            fatalError("FrontLinkSDK is not set up properly with a catalogLink")
        }
        brokerConnectViewController = GetFrontLinkSDK.brokerConnectWebViewController(brokersManager: brokersManager, delegate: self)
        guard let brokerConnectViewController else { return }
        
        if presentBrokerConnectViewControllerModally {
            present(brokerConnectViewController, animated: true)
        } else {
            navigationController?.pushViewController(brokerConnectViewController, animated: true)
        }
    }

    @objc private func brokerListUpdated() {
        brokers = brokersManager.brokers
    }
}

extension AccountConnectionsViewController: BrokerConnectViewControllerDelegate {
    func setBrokerConnectViewController(_ viewController: UIViewController) {
    }
    
    func accountsConnected(_ accounts: [FrontLinkSDK.BrokerAccountable]) {
        print(accounts)
    }
    
    func closeViewController() {
        if presentBrokerConnectViewControllerModally {
            brokerConnectViewController?.dismiss(animated: true)
        } else {
            brokerConnectViewController?.navigationController?.popViewController(animated: true)
        }
    }
}

extension AccountConnectionsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brokers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountConnectionCollectionViewCell.reuseIdentifier, for: indexPath) as! AccountConnectionCollectionViewCell
        cell.setup(broker: brokers[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 120)
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let broker = brokers[indexPath.row]
//        let viewModel = HoldingsViewModel(broker: broker, brokersManager: brokersManager)
//        let holdingsView = HoldingsView(viewModel: viewModel)
//        let vc = UIHostingController(rootView: holdingsView)
//        navigationController?.pushViewController(vc, animated: true)
//    }
}
