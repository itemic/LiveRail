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
    
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                    .frame(height: 55)
                VStack {
                    HStack {
                        HStack {
//                            HeaderIcon(text: "Home", icon: "house.fill", color: .red, index: 1, current: $selectedView)
                            HeaderIcon(text: "Timetable", icon: "list.bullet.rectangle", color: .purple, view: .timetableView, current: $currentView)
                            HeaderIcon(text: "Scheduler", icon: "timer.square", color: .orange, view: .plannerView, current: $currentView)
                            Spacer()
                        }
                        

                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gearshape.fill").imageScale(.medium).foregroundColor(.gray)
                                .padding(5)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                        .sheet(isPresented: $showingSettings) {
                            SettingsView()
                        }
                        
                    }
                }
                
            }
            .padding()
            .background(BlurView(style: .systemThinMaterial))
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct HeaderIcon: View {
    var text: String
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
