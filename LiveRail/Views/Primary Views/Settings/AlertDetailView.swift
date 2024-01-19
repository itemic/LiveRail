//
//  AlertDetailView.swift
//  LiveRail
//
//  Created by Terran Kroft on 8/8/21.
//

import SwiftUI

struct AlertDetailView: View {
    var alert: AlertInfo
    var body: some View {
        VStack {
            HStack {
                
                
                    Image(systemName: alert.alertStatus.icon)
                        .imageScale(.large)
                        .font(.title2)
                        .foregroundColor(alert.alertStatus.color)
                        .padding(8)
                        .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(alert.alertStatus.color.opacity(0.1)))
                        .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    Text(LocalizedStringKey(alert.alertStatus.text)).font(.headline)
                    Text(LocalizedStringKey(alert.Effects))
                }
                    
                
                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal)
        
        List {
            Section(footer: Text("Alert details are currently only fully available in Chinese.")) {
            
                
                VStack(alignment: .leading) {
                    Text(alert.Title).font(.headline).multilineTextAlignment(.leading).fixedSize(horizontal: false, vertical: true)
                    Divider()
                    Text(alert.Description).font(.subheadline).fixedSize(horizontal: false, vertical: true)
                }
                VStack(alignment: .leading) {
                    Text("Affected lines".uppercased()).kerning(1.05).font(.caption)
                    Text(alert.Direction)
                }
                
                VStack(alignment: .leading) {
                    Text("Affected sections".uppercased()).kerning(1.05).font(.caption)
                    Text(alert.EffectedSection)
                }
            
            Text(alert.Effects)
            }
        }
        .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle(LocalizedStringKey("SERVICE_STATUS"))
//        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}
