//
//  Utilities.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/16/21.
//

import Foundation
import SwiftUI

// https://www.vadimbulavin.com/handling-out-of-bounds-exception/
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


// source: https://medium.com/dev-genius/blur-effect-with-vibrancy-in-swiftui-bada837fdf50
struct BlurView: UIViewRepresentable {
    @AppStorage("enableTimeWarp") var enableTimeWarp = false
    typealias UIViewType = UIVisualEffectView
    
    let style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style = .systemUltraThinMaterial) {
        self.style = style
        
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: self.style)
//        uiView.backgroundColor = enableTimeWarp ? .systemIndigo : .clear
    }
    
    
}

