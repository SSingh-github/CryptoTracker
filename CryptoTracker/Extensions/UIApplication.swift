//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Sukhpreet Singh on 26/01/26.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
