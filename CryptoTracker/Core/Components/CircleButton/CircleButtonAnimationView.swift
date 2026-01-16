//
//  CircleButtonAnimationView.swift
//  CryptoTracker
//
//  Created by Sukhpreet Singh on 15/01/26.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0 : 1)
            .animation(animate ? Animation.easeInOut(duration: 1.0) : .none, value: animate)
    }
}

