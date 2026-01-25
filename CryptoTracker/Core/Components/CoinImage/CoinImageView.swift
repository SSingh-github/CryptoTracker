//
//  CoinImageView.swift
//  CryptoTracker
//
//  Created by Sukhpreet Singh on 24/01/26.
//

import SwiftUI

struct CoinImageView: View {
    
    @StateObject var vm: CoinImageViewModel
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        if let image = vm.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else if !vm.isLoading {
            Circle()
                .fill(Color.theme.shimmerBackground)
                .frame(width: 30, height: 30)
                .shimmer()
        } else {
            Image(systemName: "questionmark")
                .foregroundStyle(Color.theme.secondaryText)
        }
    }
}

#Preview {
    CoinImageView(coin: DeveloperPreview.instance.coin)
}
