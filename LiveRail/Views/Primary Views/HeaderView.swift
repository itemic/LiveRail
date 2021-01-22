//
//  HeaderView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/21/21.
//

import SwiftUI

struct HeaderView: View {
    
    @ObservedObject var data: HSRDataStore
    @Binding var currentView: HSRViews
    @Binding var showingSettings: Bool
    @Binding var selectedView: Int
    
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                    .frame(height: 55)
                VStack {
                    HStack {
                        Text("Rail \(currentView.string)").font(.title).bold()
                        Spacer()

                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gearshape.fill").imageScale(.large).foregroundColor(.gray)
                                .padding(5)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                        .sheet(isPresented: $showingSettings) {
                            SettingsView(data: data)
                        }
                        
                    }
                }
                HStack {
                    Spacer()
                    HeaderIcon(text: "Home", icon: "house.fill", color: .red, index: 1, current: $selectedView)
//                    Spacer()
                    HeaderIcon(text: "Timetable", icon: "list.bullet", color: .purple, index: 2, current: $selectedView)
//                    Spacer()
                    HeaderIcon(text: "Search", icon: "magnifyingglass", color: .orange, index: 3, current: $selectedView)
                    Spacer()
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
    
    var index: Int
    @Binding var current: Int
    
    var isSelected: Bool {
        index == current
    }
    
    
    var body: some View {
        HStack {
         
            Image(systemName: icon)
                .imageScale(.medium)
                .foregroundColor(isSelected ? color : .primary)
            if isSelected {
                Text(text)
                    .foregroundColor(color)
                    .font(.subheadline)
                    .fontWeight(.bold)

            }
        }
        
        .padding(.vertical, 10)
        .padding(.horizontal)
        .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .background(BlurView(style: .systemUltraThinMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(isSelected ? color.opacity(0.2) : Color.clear))
        .cornerRadius(10)
        .onTapGesture {
            withAnimation {
            current = index
                print("\(index) of \(current)")

            }
            
    }
        
    }
}
