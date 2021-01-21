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
                            withAnimation {
                                switch(currentView) {
                                case .plannerView:
                                    currentView = .timetableView
                                case .timetableView:
                                    currentView = .plannerView
                                }
                            }
                        }) {
                            Image(systemName: "list.bullet.below.rectangle").imageScale(.large).foregroundColor(.accentColor)
                                .padding(5)
                                .background(Color.accentColor.opacity(0.2))
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gearshape.fill").imageScale(.large).foregroundColor(.accentColor)
                                .padding(5)
                                .background(Color.accentColor.opacity(0.2))
                                .clipShape(Circle())
                        }
                        .sheet(isPresented: $showingSettings) {
                            SettingsView(data: data)
                        }
                        
                    }
                }
            }
            .padding()
            .background(BlurView())
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
}


