//
//  AccountConnectionsView.swift
//  FrontLinkSDKTestApp
//
//  Created by Alexander on 3/27/23.
//

import SwiftUI
import FrontLinkSDK

struct AccountConnectionsView: View {
    @State private var showingConnectBrokers = false

    let publisher = NotificationCenter.default.publisher(for: .brokerListUpdated)
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    ForEach(viewModel.accounts, id: \.accountId) { accountViewModel in
                        AccountConnectionView(viewModel: accountViewModel)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        Spacer()
                            .frame(width: 15)
                    }
                }
                .background(Color.background.ignoresSafeArea())
                if viewModel.isLoading {
                    FrontLoadingView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Accounts")
            .onAppear {
                viewModel.getAccounts()
            }
            .toolbar {
                Button {
                   showingConnectBrokers = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showingConnectBrokers, content: {
            BrokersConnectView(brokersManager: GetFrontLinkSDK.defaultBrokersManager) {
                showingConnectBrokers = false
                viewModel.getAccounts()
            }
        })
        .background(Color.background.ignoresSafeArea())
        .onReceive(publisher) { (output) in
            viewModel.getAccounts()
        }
    }

    init(viewModel: AccountConnectionsViewModel) {
        self.viewModel = viewModel
    }

    @ObservedObject private var viewModel: AccountConnectionsViewModel
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AccountConnectionsView(viewModel: AccountConnectionsViewModel(brokersManager: MockBrokersManager()))
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}

