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
    @Binding var startingStation: String
    @Binding var endingStation: String
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
                
                
                if (!startingStation.isEmpty && !endingStation.isEmpty && startingStation != endingStation) {
                ScrollView(showsIndicators: false) {
                    Spacer()
                        .frame(height: 120)
                    VStack {
                        
                        FareListingView(fareSchedule: data.fareSchedule[startingStation]![endingStation]!)
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
                                PlannerResultRowView(entry: entry, availability: vm.availability[entry], timetable: vm.getTimetable(for: entry.DailyTrainInfo.TrainNo), origin: startingStation, destination: endingStation)
                                    .onTapGesture {
                                        selectedTimetable = data.getStationTimetable(from: data.station(from: startingStation)!, train: entry.DailyTrainInfo.TrainNo)
                                        showingTimetable = true
                                    }
                            }
                            
                            
                        }
                        
                        Spacer()
                            .frame(height: 110)
                    }
                    .padding(.horizontal)
//                    .sheet(item: $selectedTimetable) {
//                        TrainServiceView(train: $0)
//                    }
                    
                }
                } else {

                    EmptyScreenView(icon: "tram.fill", headline: "NO_TRAINS", description: "CHOOSE_OTHER", color: .hsrColor)
 

                }
            }
            
            
            
            
            //MARK: TWO
            PlanViewPickerButtonView(origin: $startingStation, destination: $endingStation, rotation: rotationAmount)
            
            SlideoverSheetView(isOpen: $showingTimetable) {
                if let selectedTimetable = selectedTimetable {
                    TrainServiceSheetView(train: selectedTimetable, active: $showingTimetable)
                } else { EmptyView() }
            }
            
        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
        
        .onChange(of: startingStation) { newValue in
            if (!newValue.isEmpty && !endingStation.isEmpty) {
                vm.fetchQueryTimetables(from: startingStation, to: endingStation, client: .init())
                sendHaptics()
            }
        }
        .onChange(of: endingStation) { newValue in
            if (!newValue.isEmpty && !startingStation.isEmpty) {
                vm.fetchQueryTimetables(from: startingStation, to: endingStation, client: .init())
                sendHaptics()
            }
        }
       
    }
    
    
    
    func sendHaptics() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}


