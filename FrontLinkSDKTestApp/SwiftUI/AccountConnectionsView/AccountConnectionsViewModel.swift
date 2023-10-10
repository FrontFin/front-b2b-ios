//
//  AccountConnectionsViewModel.swift
//  FrontLinkSDKTestApp
//
//  Created by Alexander on 3/26/23.
//

import SwiftUI
import FrontLinkSDK

protocol AccountConnectionsViewModeling: ObservableObject {
    var accounts: [AccountConnectionViewModel] { get }
}

internal struct AccountConnectionItemViewModel: AccountConnectionViewModel {
    
    var name: String { broker.brokerName ?? broker.brokerType }
    // TODO: Fetch total value

    var accountValue: String { "" } //"$" + NumberFormatter.amountFormatter.string(from: broker.totalValue()) }

    var accountId: String { broker.accountId ?? "" }

    var accountName: String? { broker.accountName }

    var icon: UIImage? { broker.icon }

    fileprivate let broker: BrokerAccountable

    init(broker: BrokerAccountable) {
        self.broker = broker
    }
}

final class AccountConnectionsViewModel: ObservableObject, AccountConnectionsViewModeling {

    @Published var accounts: [any AccountConnectionViewModel] = []

    @Published var isLoading: Bool = false

    init(brokersManager: BrokersManaging,
         closeBlock: (() -> Void)? = nil) {
        self.brokersManager = brokersManager
        self.closeBlock = closeBlock
    }

    func getAccounts() {
        self.accounts = brokersManager.brokers.map { AccountConnectionItemViewModel(broker: $0) }
    }
    
    func close() {
        closeBlock?()
    }

    private let brokersManager: BrokersManaging

    private let closeBlock: (() -> Void)?
}
