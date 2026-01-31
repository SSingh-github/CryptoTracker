//
//  MarketDataService.swift
//  CryptoTracker
//
//  Created by Sukhpreet Singh on 31/01/26.
//


import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    
    init() {
    }
    
    func getMarketData() {
        guard let url = URL(string:"https://api.coingecko.com/api/v3/global") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(AppConfig.coinGeckoAPIKey, forHTTPHeaderField: "x-cg-demo-api-key")
        
        marketDataSubscription = NetworkingManager.download(request: request)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (receivedGlobalData) in
                self?.marketData = receivedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })

    }
}
