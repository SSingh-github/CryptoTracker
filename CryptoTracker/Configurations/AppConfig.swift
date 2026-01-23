//
//  AppConfig.swift
//  CryptoTracker
//
//  Created by Sukhpreet Singh on 23/01/26.
//

import Foundation

enum AppConfig {
    static let coinGeckoAPIKey: String = {
        guard let key = Bundle.main.object(
            forInfoDictionaryKey: "COINGECKO_API_KEY"
        ) as? String else {
            fatalError("Missing COINGECKO_API_KEY")
        }
        return key
    }()
}
