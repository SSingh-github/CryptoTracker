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
    @Published var isLoading: Bool = false
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        isLoading = true
        dataService.getCoins()
    }
    
    func addSubscribers() {
        dataService.$allCoins
            .sink {[weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }

}
