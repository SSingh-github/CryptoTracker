//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by Sukhpreet Singh on 24/01/26.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    
    init(urlString: String) {
        getCoinImage(urlString: urlString)
    }
    
    
    private func getCoinImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        imageSubscription = NetworkingManager.download(request: request)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (receivedImage) in
                self?.image = receivedImage
                self?.imageSubscription?.cancel()
            })
    }
}
