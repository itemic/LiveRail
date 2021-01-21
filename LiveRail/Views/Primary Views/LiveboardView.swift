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
                            .frame(height: 90)
                        if (data.station(from: timetableStation) != nil) {
                            StationTimetableView(station: data.station(from: timetableStation)!, data: data)
                        }
                        Spacer()
                            .frame(height: 110)
                    }
                } else {
                    VStack {
                       
                        VStack {
                            Image(systemName: "questionmark.square.dashed").imageScale(.large)
                                .foregroundColor(.purple).font(.system(size: 64))
                            Spacer().frame(height: 10)
                            Text("Select a station")
                                .font(.headline)
                            Spacer().frame(height: 5)
                            Text("Pick a station to view its scheduled services").font(.subheadline)
                                .frame(width: 200).multilineTextAlignment(.center)
                            
                        }
                        .padding()
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(10)
//                        Spacer()
//                            .frame(height: 55)
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
                                        
                }
                .padding()
                .padding(.bottom, 15)
                .background(BlurView())
                
                
            }
            .edgesIgnoringSafeArea(.all)
        }

    }
}
