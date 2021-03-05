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
    
    
    
//    TEST
    @State var showingTimetable: Bool = false
    @State var selectedDailyTimetable: RailDailyTimetable?
//    END TEST
    
    var body: some View {
        ZStack {
            VStack {
               
                if (!timetableStation.isEmpty) {
                    ScrollView {
                        Spacer()
                            .frame(height: 120)
                        if (data.station(from: timetableStation) != nil) {
                            StationTimetableView(station: data.station(from: timetableStation)!, isShow: $showingTimetable, selectedTimetable: $selectedDailyTimetable)
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
                if let selectedDailyTimetable = selectedDailyTimetable {
                    TrainServiceSheetView2(train: selectedDailyTimetable, active: $showingTimetable)
                } else { EmptyView() }
            }

        }
        
        .onChange(of: timetableStation) { _ in
            sendHaptics()
        }
       
        
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)

    }
    
    
    func sendHaptics() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
