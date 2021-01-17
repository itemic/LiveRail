//
//  PlannerHomeView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import SwiftUI

enum StationButtonType: CaseIterable {
    case origin, destination
}

struct PlannerView: View {
    @ObservedObject var data: HSRDataStore
    
    // stored as IDs 4-digit string
    @State var startingStation = ""
    @State var endingStation = ""
    @AppStorage("showAvailable") var showAvailable = false
    
    @State private var originIsActive = false
    @State private var destinationIsActive = false
    
    @State private var rotationAmount = 0.0
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @ObservedObject var queryVM = HSRQueryViewModel()
    
    func flipStations() {
        let temp = startingStation
        startingStation = endingStation
        endingStation = temp
        
        rotationAmount += 180
    }
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                //MARK: ZStack 1 - ScrollView
                ScrollView {
                    VStack {
                        
                        // MARK: HStack - Origin/Destination Buttons
                        HStack {
                                                Button(action: {
                                                    withAnimation {
                                                    originIsActive = true
                                                    }
                                                }) {
                                                    VStack {
                                                        VStack {
                                                            Text("ORIGIN")
                                                                .foregroundColor(.primary).opacity(0.8)
                                                            Spacer()
                                                        }
                        
                                                        VStack {
                        
                                                            Text(data.stationName(from: startingStation))
                                                                .foregroundColor(.white)
                                                                .font(.title2).bold()
                        
                                                        }.frame(maxWidth: .infinity, minHeight: 60)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                                                .fill(Color.accentColor)
                                                        )
                        
                        
                                                    }
                                                    //                    .padding()
                        
                        
                                                }
                                                .buttonStyle(OpacityChangingButton())
                        
                        
                                                Button(action: {
                                                    flipStations()
                                                }) {
                                                    VStack {
                                                        VStack {
                                                            Text("")
                                                                .foregroundColor(.primary).opacity(0.8)
                                                            //                            Spacer()
                                                            Image(systemName: "arrow.triangle.2.circlepath")
                                                                .font(.title)
                                                                .rotationEffect(Angle.degrees(rotationAmount))
                                                                .animation(.easeOut)
                                                        }
                        
                                                    }
                                                }
                                                //                .buttonStyle(CustomButtonStyle())
                        
                        
                                                Button(action: {
                                                    withAnimation {
                                                    destinationIsActive = true
                                                    }
                                                }) {
                                                    VStack {
                                                        VStack {
                                                            Text("DESTINATION")
                                                                .foregroundColor(.primary).opacity(0.8)
                                                            Spacer()
                                                        }
                        
                                                        VStack {
                        
                                                            Text(data.stationName(from: endingStation))
                                                                .foregroundColor(.white)
                                                                .font(.title2).bold()
                        
                                                        }.frame(maxWidth: .infinity, minHeight: 60)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                                                .fill(Color.accentColor)
                                                        )
                        
                        
                                                    }
                        
                        
                                                }
                                                .buttonStyle(OpacityChangingButton())
                        
                                            }
                        
                        
                            
                        // MARK: HStack - Fee Details
                        HStack {
                            if (!startingStation.isEmpty && !endingStation.isEmpty && startingStation != endingStation) {
                                FareListingView(fareSchedule: data.fareSchedule[startingStation]![endingStation]!)
                            }
                        }
                        .padding(.vertical)
                        
                        
                        // MARK: HStack - Train
//                        if (queryVM.queryResultTimetable.isEmpty) {
//                            HStack {
//                                Spacer()
//                                Text("No trains available for your selection")
//                                Spacer()
//                            }
//                        }

                        
                        ForEach(queryVM.queryResultTimetable
                                .sorted {
                                    $0.OriginStopTime < $1.OriginStopTime
                                }
                                .filter {
                                    showAvailable ? $0.OriginStopTime.willDepartAfterNow : true

                                }
                        ) { entry in
                            
                            HStack {
                            PlannerResultRowView(entry: entry, availability: queryVM.availability[entry])
                            }

                        }
                    }
                    .padding()
                }
//                .padding()
                
                //MARK: ZStack 2 - Overlays
                ZStack {
                    StationButtonPickerView(title: "Origin", stations: data.stations, selectedStation: $startingStation, isActive: $originIsActive)
                    StationButtonPickerView(title: "Destination", stations: data.stations, selectedStation: $endingStation, isActive: $destinationIsActive)
                }
                
                
            }
            
            .navigationTitle("Planner")
            .onChange(of: startingStation) { newValue in
                                    if (!newValue.isEmpty && !endingStation.isEmpty) {
                                        queryVM.fetchQueryTimetables(from: startingStation, to: endingStation, client: .init())
                                    }
                                }
                                .onChange(of: endingStation) { newValue in
                                    if (!newValue.isEmpty && !startingStation.isEmpty) {
                                        queryVM.fetchQueryTimetables(from: startingStation, to: endingStation, client: .init())
                                    }
                                }
            
            
            
                        
        }
    }
}


// source: https://medium.com/dev-genius/blur-effect-with-vibrancy-in-swiftui-bada837fdf50
struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView
    
    let style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style = .systemMaterial) {
        self.style = style
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: self.style)
    }
}


public struct CustomButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.body.weight(.medium))
            .padding(.vertical, 12)
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                    .fill(Color.accentColor)
            )
            .opacity(configuration.isPressed ? 0.4 : 1.0)
    }
}

public struct OpacityChangingButton: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.4 : 1.0)
    }
}
