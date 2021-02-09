//
//  EmptyScreenView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/22/21.
//

import SwiftUI

struct EmptyScreenView: View {
    var icon: String
    var headline: String
    var description: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon).imageScale(.large)
                .foregroundColor(color).font(.system(size: 64))
                .fixedSize()
            Text(LocalizedStringKey(headline))
                .font(.headline)
            Text(LocalizedStringKey(description)).font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(width: 250, height: 250)
        .background(color.opacity(0.2))
        .cornerRadius(10)
    }
}

struct EmptyScreenView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyScreenView(icon: "magnifyingglass", headline: "This is a headline!", description: "Can we try a two-lined sub headline thing?", color: .purple)
    }
}
