//
//  CoinRowShimmerView.swift
//  CryptoTracker
//
//  Created by Sukhpreet Singh on 23/01/26.
//

import SwiftUI

struct CoinRowShimmerView: View {
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.theme.shimmerBackground)
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.theme.shimmerBackground)
                    .frame(width: 120, height: 14)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.theme.shimmerBackground)
                    .frame(width: 60, height: 10)
            }

            Spacer()

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.theme.shimmerBackground)
                .frame(width: 80, height: 14)
        }
        .padding(.vertical, 10)
        .shimmer()
    }
}


#Preview {
    CoinRowShimmerView()
}
