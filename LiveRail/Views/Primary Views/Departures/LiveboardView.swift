//
//  LiveboardView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/21/21.
//

import SwiftUI

struct LiveboardView: View {
    
    
    @Binding var timetableStationObject: Station?
    
    
//    TEST
    @State var showingTimetable: Bool = false
    @State var selectedDailyTimetable: RailDailyTimetable?
//    END TEST
    
    var body: some View {
        ZStack {
            VStack {
               
                if let timetableStationObject = timetableStationObject {
                    ScrollView {
                        Spacer()
                            .frame(height: 120)
                            StationTimetableView(station: timetableStationObject, isShow: $showingTimetable, selectedTimetable: $selectedDailyTimetable)
                        Spacer()
                            .frame(height: 110)
                    }
                } else {
                    EmptyScreenView(icon: "list.bullet.rectangle", headline: "SELECT_STATION", description: "PICK_TO_VIEW_DEPARTURES", color: Color(UIColor.systemIndigo))
                }
                
            }
            
            LiveBoardPickerButtonView(station: $timetableStationObject)

            SlideoverSheetView(isOpen: $showingTimetable) {
                if let selectedDailyTimetable = selectedDailyTimetable {
                    TrainServiceSheetView(train: selectedDailyTimetable, active: $showingTimetable)
                } else { EmptyView() }
            }

        }
        
        .onChange(of: timetableStationObject) { _ in
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
