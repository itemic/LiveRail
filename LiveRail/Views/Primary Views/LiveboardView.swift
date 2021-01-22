//
//  LiveboardView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/21/21.
//

import SwiftUI

struct LiveboardView: View {
    
    @ObservedObject var data: HSRDataStore
    @StateObject var lm = LocationManager.shared
    
    @Binding var timetableStation: String
    @Binding var timetableIsActive: Bool
    
    var body: some View {
        ZStack {
            VStack {
               
                if (!timetableStation.isEmpty) {
                    ScrollView {
                        Spacer()
                            .frame(height: 180)
                        if (data.station(from: timetableStation) != nil) {
                            StationTimetableView(station: data.station(from: timetableStation)!, data: data)
                        }
                        Spacer()
                            .frame(height: 110)
                    }
                } else {
                        EmptyScreenView(icon: "questionmark.square.dashed", headline: "Select a station", description: "Pick a station to view its scheduled services", color: .purple)
                }
                
            }
            
            VStack {
                
                
                Spacer()
                HStack {
                    Button(action: {
                        withAnimation {
                            timetableIsActive = true
                        }
                    }) {
                        VStack {
                            
                            VStack {
                                Text(data.stationName(from: timetableStation))
                                    .foregroundColor(.white)
                                    .font(.title2).bold()
                            }.frame(maxWidth: .infinity, minHeight: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(Color.purple)
                            )
                        }
                    }
                    .buttonStyle(OpacityChangingButton())
                                        
                }
                .padding()
                .padding(.bottom, 15)
                .background(BlurView())
                
                
            }
            .edgesIgnoringSafeArea(.all)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)

    }
}
