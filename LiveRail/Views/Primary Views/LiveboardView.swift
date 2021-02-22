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
                            .frame(height: 120)
                        if (data.station(from: timetableStation) != nil) {
                            StationTimetableView(station: data.station(from: timetableStation)!)
                        }
                        Spacer()
                            .frame(height: 110)
                    }
                } else {
                        EmptyScreenView(icon: "questionmark.square.dashed", headline: "SELECT_STATION", description: "PICK_TO_VIEW_DEPARTURES", color: .purple)
                }
                
            }
            
            LiveBoardPickerButtonView(stn: $timetableStation)
            

        }
       
        
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)

    }
}
