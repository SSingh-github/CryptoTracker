//
//  HomeStatsView.swift
//  CryptoTracker
//
//  Created by Sukhpreet Singh on 27/01/26.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                if vm.isMarketDataLoading {
                    ForEach(0..<3, id: \.self) { _ in
                        StatisticShimmerView()
                            .frame(width: geometry.size.width / 3)
                    }
                } else {
                    ForEach(vm.statistics) { stat in
                        StatisticView(stat: stat)
                            .frame(width: geometry.size.width / 3)
                    }
                }
            }
            .frame(width: geometry.size.width,
                   alignment: showPortfolio ? .trailing : .leading
            )
        }
        .frame(height: 80)
    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(false))
}
