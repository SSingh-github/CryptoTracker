//
//  StatisticView.swift
//  CryptoTracker
//
//  Created by Sukhpreet Singh on 27/01/26.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees:(stat.percentageChange ?? 0) >= 0 ? 0 : 180))
                
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

struct StatisticShimmerView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.theme.shimmerBackground)
                .frame(width: 60, height: 10)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.theme.shimmerBackground)
                .frame(width: 80, height: 16)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.theme.shimmerBackground)
                .frame(width: 50, height: 10)
        }
        .shimmer()
    }
}



#Preview {
    StatisticView(stat: DeveloperPreview.instance.stat1)
}
