//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Sukhpreet Singh on 20/01/26.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var isCoinDataLoading: Bool = false
    @Published var isMarketDataLoading: Bool = false
    @Published var searchText: String = ""
    @Published var statistics: [StatisticModel] = []
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        isCoinDataLoading = true
        coinDataService.getCoins()
        isMarketDataLoading = true
        marketDataService.getMarketData()
    }
    
    func addSubscribers() {
        
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink {[weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        coinDataService.$allCoins
            .sink {[weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.isCoinDataLoading = false
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map (mapMarketData)
            .sink { [weak self] (stats) in
                self?.statistics = stats
                self?.isMarketDataLoading = false
            }
            .store(in: &cancellables)
       
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    
    func reloadData() {
        isCoinDataLoading = true
        coinDataService.getCoins()
        isMarketDataLoading = true
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func filterCoins(text: String) -> [CoinModel] {
        let coins = coinDataService.allCoins
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapMarketData(returnedMarketData: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        guard let marketData = returnedMarketData else {
            return []
        }
        
        var stats: [StatisticModel] = []
        
        let marketCap = StatisticModel(title: "Market Cap", value: marketData.marketCap, percentageChange: marketData.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: marketData.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: marketData.btcDominance)
        
        let portfolioValue = portfolioCoins.map({$0.currentHoldingsValue}).reduce(0, +)
        
        let previousValue =
        portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }

}
