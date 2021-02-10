//
//  HeaderView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/21/21.
//

import SwiftUI

struct HeaderView: View {
    
    @StateObject var data = HSRDataStore.shared
    @Binding var currentView: RailViews
    @Binding var showingSettings: Bool
//    @Binding var selectedView: Int
    @AppStorage("enableTimeWarp") var enableTimeWarp = false
    
    var body: some View {
        VStack {
            VStack {
                
                ZStack {
                    Spacer()
                        .frame(height: 20)
                        
                            
                            
                    if (enableTimeWarp) {
                            HStack {
                                if (enableTimeWarp) {
                            Image(systemName: "timelapse")
                                    Text("TIME WARP")
                            Text("∞").bold()
                                }
                        }
                        .font(.system(.caption2, design: .monospaced))
                        .fixedSize()
                        .padding(.vertical, 2)
                        .padding(.leading, 2)
                        .padding(.trailing, 8)
                        .background(Color(UIColor.systemIndigo))
                        .cornerRadius(10.0)
                        .foregroundColor(.white)
                        .offset(y: 10)
                        
                    }
                }
                
                
                VStack {
                    HStack {
                        HStack {
                            HeaderIcon(text: "Departures", icon: "list.bullet.rectangle", color: .purple, view: .timetableView, current: $currentView)
                            HeaderIcon(text: "Trains", icon: "arrow.left.and.right.square", color: .orange, view: .plannerView, current: $currentView)
                            Spacer()
                        }
                        

                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .imageScale(.medium)
                                .foregroundColor(.gray)
                                .font(.system(size: 24))
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .background(BlurView(style: .systemUltraThinMaterial))
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.clear))
                                .cornerRadius(10)

                        }
                        
                        .sheet(isPresented: $showingSettings) {
                            SettingsView()
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
