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
    private var brokersManager = GetFrontLinkSDK.defaultBrokersManager
    
    @IBOutlet private weak var collectionView: UICollectionView!

    private var brokers: [BrokerAccountable] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

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

    @objc
    private func connectBrokers() {
        guard let catalogLink = GetFrontLinkSDK.catalogLink, !catalogLink.isEmpty else {
            fatalError("FrontLinkSDK is not set up properly with a catalogLink")
        }
        GetFrontLinkSDK.connectBrokers(in: self, brokersManager: brokersManager)
    }

    @objc private func brokerListUpdated() {
        brokers = brokersManager.brokers
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
