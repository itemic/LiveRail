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
                        .frame(height: 110)
                    VStack {
                        HStack {
                            if (!startingStation.isEmpty && !endingStation.isEmpty && startingStation != endingStation) {
                                FareListingView(fareSchedule: data.fareSchedule[startingStation]![endingStation]!)
                            } else {
                                // EMPTY
                                Spacer()
                                VStack {
                                    Spacer(minLength: 100)
                                VStack {
                                    Image(systemName: "face.dashed").imageScale(.large)
                                        .foregroundColor(.accentColor)
                                    Spacer()
                                    Text("No trains found!")
                                        .font(.headline)
                                    Text("Try checking out different stations").font(.subheadline)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.accentColor.opacity(0.2))
                                .cornerRadius(10)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        .padding(.vertical)
                        
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

                        
                    VStack {
                       
                        VStack {
                            Image(systemName: "questionmark.square.dashed").imageScale(.large)
                                .foregroundColor(.accentColor).font(.system(size: 64))
                            Spacer().frame(height: 10)
                            Text("No trains found!")
                                .font(.headline)
                            Spacer().frame(height: 5)
                            Text("Try checking out different stations").font(.subheadline)
                                .frame(width: 200).multilineTextAlignment(.center)
                            
                        }
                        .padding()
                        .background(Color.accentColor.opacity(0.2))
                        .cornerRadius(10)

                    }

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


