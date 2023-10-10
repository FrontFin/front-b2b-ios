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

        let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
            
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
                let del = UIContextualAction(style: .destructive, title: "Delete") {
                    [weak self] action, view, completion in
                    self?.deleteBroker(at: indexPath)
                    completion(true)
                }
                return UISwipeActionsConfiguration(actions: [del])
            }
            configuration.headerMode = .none
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            return section
        }
        collectionView.collectionViewLayout = layout
        
        brokerListUpdated()
        NotificationCenter.default.addObserver(self, selector: #selector(brokerListUpdated), name: .brokerListUpdated, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        var items: [UIBarButtonItem] = []
        
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(connectBrokers))
        plusButton.accessibilityIdentifier = "plus"
        items.append(plusButton)
        navigationItem.rightBarButtonItems = items
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(dismissViewController))
    }

    private func deleteBroker(at indexPath: IndexPath) {
        
        guard indexPath.row < brokersManager.brokers.count else {
            return
        }
        let broker = brokersManager.brokers[indexPath.row]
        brokersManager.remove(broker: broker)
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
}
