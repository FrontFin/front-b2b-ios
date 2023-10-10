//
//  MockBrokersManager.swift
//  FrontLinkSDKTestApp
//
//  Created by Alexander on 3/28/23.
//

import Foundation
import FrontLinkSDK

final class MockBrokerAccount: BrokerAccountable {
    var id: String

    var accessToken: String?

    var accountId: String?

    var accountName: String?

    var accessTokenUpdatedAt: Date?

    var brokerType: String

    var refreshToken: String?

    var brokerName: String?

    var expiresInSeconds: Double?

    var refreshTokenExpiresInSeconds: Int?

    var brokerLogoBase64: String?

    var colorHEX: String?

    var brokerBrandInfo: BrandInfo?

    var status: BrokerAuthenticationStatus

    var refreshTokenUpdatedAt: Date?

    func update(broker: BrokerAccountable) {}

    init(id: String, accessToken: String? = nil, accountId: String? = nil, accountName: String? = nil, accessTokenUpdatedAt: Date? = nil, brokerType: String, refreshToken: String? = nil, brokerName: String? = nil, expiresInSeconds: Double? = nil, refreshTokenExpiresInSeconds: Int? = nil, brokerLogoBase64: String? = nil, colorHEX: String? = nil, brokerBrandInfo: BrandInfo? = nil, status: BrokerAuthenticationStatus = .succeeded, refreshTokenUpdatedAt: Date? = nil) {
        self.id = id
        self.accessToken = accessToken
        self.accountId = accountId
        self.accountName = accountName
        self.accessTokenUpdatedAt = accessTokenUpdatedAt
        self.brokerType = brokerType
        self.refreshToken = refreshToken
        self.brokerName = brokerName
        self.expiresInSeconds = expiresInSeconds
        self.refreshTokenExpiresInSeconds = refreshTokenExpiresInSeconds
        self.brokerLogoBase64 = brokerLogoBase64
        self.colorHEX = colorHEX
        self.brokerBrandInfo = brokerBrandInfo
        self.status = status
        self.refreshTokenUpdatedAt = refreshTokenUpdatedAt
    }
}

final class MockBrokersManager: BrokersManaging {
    var brokers: [BrokerAccountable] = [
        MockBrokerAccount(id: "1", accountName: "Test 1", brokerType: ""),
        MockBrokerAccount(id: "2", accountName: "Test 2", brokerType: ""),
        MockBrokerAccount(id: "3", accountName: "Test 3", brokerType: "")
    ]

    func saveBrokers() {}
    func add(broker account: BrokerAccountable) {}
    func add(brokers: [BrokerAccountable]) {}
    func remove(broker: BrokerAccountable) {}
}
