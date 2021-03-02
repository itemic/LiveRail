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
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
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
        if (!reduceTransparency) {
        uiView.effect = UIBlurEffect(style: self.style)
        }
//        uiView.backgroundColor = enableTimeWarp ? .systemIndigo : .clear
    }
    
    
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}


// SRC: https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui 
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

extension Color {
    static let hsrColor = Color("hsrColor")
    static let northColor = Color("northColor")
    static let southColor = Color("southColor")
}
