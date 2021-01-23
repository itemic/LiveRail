//
//  LiveboardView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/21/21.
//

import SwiftUI

struct LiveboardView: View {
    
    @StateObject var data = HSRDataStore.shared
    @StateObject var lm = LocationManager.shared
    
    @Binding var timetableStation: String
    @Binding var timetableIsActive: Bool
    
    var body: some View {
        ZStack {
            VStack {
               
                if (!timetableStation.isEmpty) {
                    ScrollView {
                        Spacer()
                            .frame(height: 150)
                        if (data.station(from: timetableStation) != nil) {
                            StationTimetableView(station: data.station(from: timetableStation)!)
                        }
                        Spacer()
                            .frame(height: 110)
                    }
                } else {
                        EmptyScreenView(icon: "questionmark.square.dashed", headline: "Select a station", description: "Pick a station to view its scheduled services", color: .purple)
                }
                
            }
            
            LiveBoardPickerButtonView(station: data.stationName(from: timetableStation) ?? "Station", activeTimetable: $timetableIsActive)
            

        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)

    }
}
