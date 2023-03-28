//
//  AccountConnectionView.swift
//  FrontLinkSDKTestApp
//
//  Created by Alexander on 3/27/23.
//

import SwiftUI
import FrontLinkSDK

protocol AccountConnectionViewModel {
    var name: String { get }
    var accountValue: String { get }
    var accountId: String { get }
    var accountName: String? { get }
    var icon: UIImage? { get }
    var brokerAuthentication: BrokerAuthentication { get }
}

struct AccountConnectionView: View {
    var body: some View {
        HStack(alignment: .top) {
            icon.frame(width: 40, height: 40)
                .clipShape(Capsule())
                .foregroundColor(.white)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .foregroundColor(.white)
                    .font(.title2)
                Spacer()
                    .frame(height: 20)
                Text(viewModel.accountName ?? "")
                    .foregroundColor(.white)
                    .font(.title3)
                Text(viewModel.accountId)
                    .foregroundColor(.white)
                    .font(.callout)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.cell)
    }

    private var icon: Image {
        guard let icon = viewModel.icon else {
            return Image(systemName: "questionmark.circle")
        }
        return Image(uiImage: icon)
    }

    init(viewModel: AccountConnectionViewModel) {
        self.viewModel = viewModel
    }

    private let viewModel: AccountConnectionViewModel
}
