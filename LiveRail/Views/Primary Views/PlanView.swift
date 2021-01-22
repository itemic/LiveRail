//
//  PlanView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/21/21.
//

import SwiftUI

struct PlanView: View {
    
    @ObservedObject var vm: HSRQueryViewModel
    @ObservedObject var data: HSRDataStore
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
                        .frame(height: 180)
                    VStack {
                        
                        
                            if (!startingStation.isEmpty && !endingStation.isEmpty && startingStation != endingStation) {
                                HStack {
                                FareListingView(fareSchedule: data.fareSchedule[startingStation]![endingStation]!)
                                }
                                .padding(.vertical)
                            }
                        
                        
                        
                        ForEach(vm.queryResultTimetable
                                    .sorted {
                                        $0.OriginStopTime < $1.OriginStopTime
                                    }
                                    .filter {
                                        showAvailable ? true : $0.OriginStopTime.willDepartAfterNow
                                        
                                    }
                        ) { entry in
                            HStack {
                                PlannerResultRowView(data: data, entry: entry, availability: vm.availability[entry])
                            }
                            
                        }
                        Spacer()
                            .frame(height: 110)
                    }
                    .padding(.horizontal)
                }
                } else {
//                    EmptyScreenView(icon: "questionmark.square.dashed", headline: "Select a station", description: "Pick a station to view its scheduled services", color: .purple)

                        EmptyScreenView(icon: "face.dashed", headline: "No trains found", description: "Try checking out different stations", color: .orange)

                }
            }
            
            
            //MARK: TWO
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        withAnimation {
                            originIsActive = true
                        }
                    }) {
                        VStack {
                            VStack {
                                Text(data.stationName(from: startingStation))
                                    .foregroundColor(.white)
                                    .font(.title2).bold()
                                
                            }.frame(maxWidth: .infinity, minHeight: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(Color.accentColor)
                            )
                        }
                    }
                    .buttonStyle(OpacityChangingButton())
                    Button(action: {
                        flipStations()
                    }) {
                        VStack {
                            VStack {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.title)
                                    .rotationEffect(Angle.degrees(rotationAmount))
                                    .animation(.easeOut)
                            }
                        }
                    }
                    Button(action: {
                        withAnimation {
                            destinationIsActive = true
                        }
                    }) {
                        VStack {
                            VStack {
                                Text(data.stationName(from: endingStation))
                                    .foregroundColor(.white)
                                    .font(.title2).bold()
                            }.frame(maxWidth: .infinity, minHeight: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(Color.accentColor)
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
    
    func flipStations() {
        let temp = startingStation
        startingStation = endingStation
        endingStation = temp
        
        rotationAmount += 180
    }
    
    func sendHaptics() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}


