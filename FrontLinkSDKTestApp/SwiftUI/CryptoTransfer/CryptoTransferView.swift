//
//  CryptoTransferView.swift
//  FrontLinkSDKTestApp
//
//  Created by Alexander on 6/5/23.
//

import SwiftUI
import FrontLinkSDK

struct CryptoTransferView: View {
    @State private var showingConnectBrokers = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Link the origin account where you wish to transfer assets from.")
                .padding(.leading, 30)
                .padding(.trailing, 30)
            .multilineTextAlignment(.center)
            Button {
                showingConnectBrokers = true
            } label: {
                Text("Connect origin account")
            }
                .padding(.leading, 50)
                .padding(.trailing, 50)
                .frame(height: 40)
                .foregroundColor(.white)
                .background(Color("Blueberry30"))
                .clipShape(Capsule())
                .sheet(isPresented: $showingConnectBrokers, content: {
                    BrokersConnectView(brokersManager: GetFrontLinkSDK.defaultBrokersManager) {
                        showingConnectBrokers = false
                        dismiss()
                    }
                })
        }
    }
}

struct CryptoTransferView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoTransferView()
    }
}
