//
//  HeaderView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/21/21.
//

import SwiftUI

struct HeaderView: View {
    
    @Binding var currentView: RailViews
    @Binding var showingSettings: Bool
//    @StateObject var store = AlertStore.shared
    @EnvironmentObject var network: NetworkStatus
//    @AppStorage("showServiceAlert") var showServiceAlert = true
    
    var body: some View {
        VStack {
            VStack {
                
                ZStack {
                    Spacer()
                        .frame(height: 30)
                        .padding(.vertical, 2)
                        .padding(.leading, 2)
                        .padding(.trailing, 8)
                    
                   
                }
                
                
                VStack {
                    HStack {
                        HStack {
                            HeaderIcon(text: "Departures", icon: "list.bullet.rectangle", color: Color(UIColor.systemIndigo), view: .timetableView, current: $currentView)
                            HeaderIcon(text: "Trains", icon: "tram.fill", color: .hsrColor, view: .plannerView, current: $currentView)
                            Spacer()
                        }
                        
                        

                        
                        
                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .imageScale(.medium)
                                .foregroundColor(.gray)
                                .font(.system(size: 18))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 8)
                                .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .overlay(
                                    ZStack(alignment: .topTrailing) {
                                        Color.clear
                                        Image(systemName: network.connected ? "wifi" : "wifi.exclamationmark")
                                            .font(.system(size: 12))
                                            .padding(2)
                                            .foregroundColor(network.connected ? .clear : .red)
                                }
                                    
                                )
                                .cornerRadius(10)

                        }
                        
                        .sheet(isPresented: $showingSettings) {
//                            SettingsView()
                            SettingsView()
                                .environmentObject(network)
                        }
                        
                        
                    }
                    
                    
                }
                
            }
            .padding(15)
            .background(BlurView(style: .systemThinMaterial))
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct HeaderIcon: View {
    var text: LocalizedStringKey
    var icon: String
    var color: Color
    
    
    var view: RailViews
    @Binding var current: RailViews
    
    var isSelected: Bool {
        view == current
    }
    
    
    var body: some View {
        HStack {
         
            Image(systemName: icon)
                .imageScale(.medium)
                .foregroundColor(isSelected ? color : .primary)
                .font(.system(size: 24))
                .frame(width: 30, height: 30)
            if isSelected {
                Text(text)
                    .foregroundColor(color)
                    .font(.headline)
                    .fontWeight(.bold)

            }
        }
        
        .padding(.vertical, 8)
        .padding(.horizontal)
        .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .background(BlurView(style: .systemUltraThinMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(isSelected ? color.opacity(0.2) : Color.clear))
        .cornerRadius(10)
        .onTapGesture {
            withAnimation {
            current = view
            }
            
    }
        
    }
}
