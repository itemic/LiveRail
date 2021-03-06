//
//  PlanView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/21/21.
//

import SwiftUI

struct PlanView: View {
    
    @ObservedObject var vm: HSRQueryViewModel
    @StateObject var data = HSRDataStore.shared
    
    
    @Binding var startingStationObject: Station?
    @Binding var endingStationObject: Station?
    
    @Binding var originIsActive: Bool
    @Binding var destinationIsActive: Bool
    
    @AppStorage("showAvailable") var showAvailable = false
    @State private var rotationAmount = 0.0
    
    @State var showingTimetable: Bool = false
    @State var selectedDailyTimetable: RailDailyTimetable?
    
    
    
    var body: some View {
        ZStack {
            //MARK: ONE
            VStack {
                
                
                if (startingStationObject != nil && endingStationObject != nil && startingStationObject != endingStationObject) {
                    ScrollView(showsIndicators: false) {
                        Spacer()
                            .frame(height: 120)
                        FareListingView(fareSchedule: data.fareSchedule[startingStationObject!.StationID]![endingStationObject!.StationID]!)
                            .padding(.bottom, 10)
                        PlanTimetableView(origin: startingStationObject, destination: endingStationObject, isShow: $showingTimetable, selectedTimetable: $selectedDailyTimetable)
                        Spacer()
                            .frame(height: 110)
                        
                        
                    }
                } else {
                    
                    EmptyScreenView(icon: "tram.fill", headline: "NO_TRAINS", description: "CHOOSE_OTHER", color: .hsrColor)
                    
                    
                }
            }
            
            
            
            
            //MARK: TWO
            PlanViewPickerButtonView(originObject: $startingStationObject, destinationObject: $endingStationObject, rotation: rotationAmount)
            
            SlideoverSheetView(isOpen: $showingTimetable) {
                if let selectedTimetable = selectedDailyTimetable {
                    TrainServiceSheetView2(train: selectedTimetable, active: $showingTimetable)
                } else { EmptyView() }
            }
            
        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
        
        .onChange(of: startingStationObject) { newValue in
            if (newValue != nil && endingStationObject != nil) {
                vm.fetchQueryTimetables(from: startingStationObject!, to: endingStationObject!, client: .init())
            }
        }
        .onChange(of: endingStationObject) { newValue in
            if (newValue != nil  && startingStationObject != nil) {
                vm.fetchQueryTimetables(from: startingStationObject!, to: endingStationObject!, client: .init())
            }
        }       
    }
    
    
    
    func sendHaptics() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}


