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
    
    @State var selectedTimetable: StationTimetable?
    @State var showingTimetable: Bool = false
    var body: some View {
        ZStack {
            VStack {
               
                if (!timetableStation.isEmpty) {
                    ScrollView {
                        Spacer()
                            .frame(height: 120)
                        if (data.station(from: timetableStation) != nil) {
                            StationTimetableView(station: data.station(from: timetableStation)!, selectedTrain: $selectedTimetable, isShow: $showingTimetable)
                        }
                        Spacer()
                            .frame(height: 110)
                    }
                } else {
                    EmptyScreenView(icon: "list.bullet.rectangle", headline: "SELECT_STATION", description: "PICK_TO_VIEW_DEPARTURES", color: Color(UIColor.systemIndigo))
                }
                
            }
            
            LiveBoardPickerButtonView(stn: $timetableStation)

            SlideoverSheetView(isOpen: $showingTimetable) {
                if let selectedTimetable = selectedTimetable {
                    TrainServiceSheetView(train: selectedTimetable, active: $showingTimetable)
                } else { EmptyView() }
            }

        }
        
       
       
        
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)

    }
}
