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
    
    @State var selectedTimetable: StationTimetable? = nil
    @State var showingTimetable: Bool = false
    
    
   
    var body: some View {
        ZStack {
            //MARK: ONE
            VStack {
                
                
                if (startingStationObject != nil && endingStationObject != nil && startingStationObject != endingStationObject) {
                ScrollView(showsIndicators: false) {
                    Spacer()
                        .frame(height: 120)
                    VStack {
                        
                        FareListingView(fareSchedule: data.fareSchedule[startingStationObject!.StationID]![endingStationObject!.StationID]!)
                            .padding(.bottom, 10)
                        ForEach(vm.queryResultTimetable
                                    .sorted {
                                        $0.OriginStopTime < $1.OriginStopTime
                                    }
                                    .filter {
                                        showAvailable ? true : Date.compare(to: $0.OriginStopTime.DepartureTime)
                                    }
                        ) { entry in
                            HStack {
                                PlannerResultRowView(entry: entry, availability: vm.availability[entry], timetable: vm.getTimetable(for: entry.DailyTrainInfo.TrainNo), origin: startingStationObject, destination: endingStationObject)
//                                    .onTapGesture {
//                                        selectedTimetable = data.getStationTimetable(from: data.station(from: startingStation)!, train: entry.DailyTrainInfo.TrainNo)
//                                        showingTimetable = true
//                                    }
                            }
                            
                            
                        }
                        
                        Spacer()
                            .frame(height: 110)
                    }
                    .padding(.horizontal)
                    
                }
                } else {

                    EmptyScreenView(icon: "tram.fill", headline: "NO_TRAINS", description: "CHOOSE_OTHER", color: .hsrColor)
 

                }
            }
            
            
            
            
            //MARK: TWO
            PlanViewPickerButtonView(originObject: $startingStationObject, destinationObject: $endingStationObject, rotation: rotationAmount)
            
            SlideoverSheetView(isOpen: $showingTimetable) {
                if let selectedTimetable = selectedTimetable {
                    TrainServiceSheetView(train: selectedTimetable, active: $showingTimetable)
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


