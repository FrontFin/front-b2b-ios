//
//  AccountConnectionsViewController.swift
//  FrontLinkSDKTestApp
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(dismissViewController))
    }

    @objc private func connectBrokers() {
        guard GetFrontLinkSDK.isSetUp else {
            fatalError("FrontLinkSDK is not set up properly")
        }
        brokerConnectViewController = GetFrontLinkSDK.brokerConnectWebViewController(brokersManager: brokersManager, delegate: self)
        guard let brokerConnectViewController else { return }
        
        if presentBrokerConnectViewControllerModally {
            present(brokerConnectViewController, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.pushViewController(brokerConnectViewController, animated: true)
        }
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
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
    
    func transferFinished(_ transfer: FrontLinkSDK.TransferFinished) {
    }
    
    func closeViewController(withConfirmation: Bool) {
        let onClose = {
            if self.presentBrokerConnectViewControllerModally {
                self.brokerConnectViewController?.dismiss(animated: true)
            } else {
                self.brokerConnectViewController?.navigationController?.setNavigationBarHidden(false, animated: true)
                self.brokerConnectViewController?.navigationController?.popViewController(animated: true)
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
