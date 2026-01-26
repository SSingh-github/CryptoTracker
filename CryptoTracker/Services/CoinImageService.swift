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
    private let coin: CoinModel
    private let fileManager =  LocalFileManager.instance
    private let imageName: String
    private let folderName = "coin_images"
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            self.image = savedImage
            print("fetched image from file manager")
        } else {
            downloadCoinImage()
            print("downloaded image from internet")
        }
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        imageSubscription = NetworkingManager.download(request: request)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (receivedImage) in
                guard let self = self, let downloadedImage = receivedImage else {return}
                self.image = receivedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: imageName, folderName: folderName)
            })
    }
}
