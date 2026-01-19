//
//  CoinModel.swift
//  CryptoTracker
//
//  Created by Sukhpreet Singh on 19/01/26.
//

import Foundation


//coingecko api info
/*
 https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&price_change_percentage=24h&order=market_cap_desc&sparkline=true&per_page=250&page=1
 
 {
 "id": "bitcoin",
 "symbol": "btc",
 "name": "Bitcoin",
 "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
 "current_price": 92948,
 "market_cap": 1857409393537,
 "market_cap_rank": 1,
 "fully_diluted_valuation": 1857409393537,
 "total_volume": 41625570439,
 "high_24h": 95468,
 "low_24h": 92263,
 "price_change_24h": -2177.5295798413863,
 "price_change_percentage_24h": -2.28912,
 "market_cap_change_24h": -42788571367.936035,
 "market_cap_change_percentage_24h": -2.2518,
 "circulating_supply": 19977803,
 "total_supply": 19977803,
 "max_supply": 21000000,
 "ath": 126080,
 "ath_change_percentage": -26.2788,
 "ath_date": "2025-10-06T18:57:42.558Z",
 "atl": 67.81,
 "atl_change_percentage": 136972.67707,
 "atl_date": "2013-07-06T00:00:00.000Z",
 "roi": null,
 "last_updated": "2026-01-19T10:50:54.495Z",
 "sparkline_in_7d": {
 "price": [
 92000.56069703125,
 91685.52725626926
 ]
 },
 "price_change_percentage_24h_in_currency": -2.2891209968226702
 }
 */


struct CoinModel: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H: Double?
    let priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }
    
    func updateHoldings(amount: Double) -> CoinModel {
        return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
    }
    
    var currentHoldingsValue: Double {
        return (currentHoldings ?? 0) * currentPrice
    }
    
    var rank: Int {
        return Int(marketCapRank ?? 0)
    }
    
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}
