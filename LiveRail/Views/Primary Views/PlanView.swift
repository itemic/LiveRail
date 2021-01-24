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
    
    var body: some View {
        ZStack {
            //MARK: ONE
            VStack {
                
                
                if (!startingStation.isEmpty && !endingStation.isEmpty && startingStation != endingStation) {
                ScrollView(showsIndicators: false) {
                    Spacer()
                        .frame(height: 150)
                    VStack {
                        
                        
//                            if (!startingStation.isEmpty && !endingStation.isEmpty && startingStation != endingStation) {
//                                HStack {
//                                FareListingView(fareSchedule: data.fareSchedule[startingStation]![endingStation]!)
//                                }
//                                .padding(.vertical)
//                            }
                        
                        
                        
                        ForEach(vm.queryResultTimetable
                                    .sorted {
                                        $0.OriginStopTime < $1.OriginStopTime
                                    }
                                    .filter {
                                        showAvailable ? true : $0.OriginStopTime.willDepartAfterNow
                                    }
                        ) { entry in
                            HStack {
                                PlannerResultRowView(entry: entry, availability: vm.availability[entry], timetable: vm.getTimetable(for: entry.DailyTrainInfo.TrainNo), origin: startingStation, destination: endingStation)
                            }
                            
                        }
                        Spacer()
                            .frame(height: 110)
                    }
                    .padding(.horizontal)
                }
                } else {

                        EmptyScreenView(icon: "face.dashed", headline: "No trains found", description: "Try checking out different stations", color: .orange)

                }
            }
            
            
            
            //MARK: TWO
            PlanViewPickerButtonView(origin: $startingStation, destination: $endingStation, oActive: $originIsActive, dActive: $destinationIsActive, rotation: rotationAmount)
            
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


