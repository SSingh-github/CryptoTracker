//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Sukhpreet Singh on 23/01/26.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    init() {
        //self.getCoins()
    }
    
    func getCoins() {
        guard let url = URL(string:"https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&price_change_percentage=24h&order=market_cap_desc&sparkline=true&per_page=250&page=1") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(AppConfig.coinGeckoAPIKey, forHTTPHeaderField: "x-cg-demo-api-key")
        
        coinSubscription = NetworkingManager.download(request: request)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (receivedCoins) in
                self?.allCoins = receivedCoins
                self?.coinSubscription?.cancel()
            })

    }
}
