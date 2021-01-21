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
                Spacer()
                    .frame(height: 75)
                ScrollView {
                    if (data.station(from: timetableStation) != nil) {
                        
                        
                        StationTimetableView(station: data.station(from: timetableStation)!, data: data)
                        
                        
                    }
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
                    
                    
                    if let status = lm.status {
                        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
                    Button(action: {
                        if let nearest = lm.closestStation(stations: data.stations)?.StationID {
                            timetableStation = nearest
                        }
                    }) {
                        VStack {

                            VStack {
                                Image(systemName: "location.fill")
                                    .font(.system(.title2))
                                    .foregroundColor(.white)

                            }.frame(maxWidth: 60, minHeight: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(Color.purple)
                            )
                        }
                    }
                    .buttonStyle(OpacityChangingButton())
                    }
                    }
                    
                    
                }
                .padding()
                .padding(.bottom, 15)
                .background(BlurView())
                
                
            }
            .edgesIgnoringSafeArea(.all)
        }

    }
}
