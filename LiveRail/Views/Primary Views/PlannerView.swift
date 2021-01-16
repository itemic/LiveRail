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
    @State var showingOverlay = false
    @State private var lastPressed: StationButtonType = .origin
    
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
                Form {
                    
                    Section(footer: HStack {
                        
                        
                        Button(action: {
                            lastPressed = .origin
                            showingOverlay.toggle()
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
                                    
                                }.frame(maxWidth: .infinity, minHeight: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 14.0, style: .continuous)
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
                            lastPressed = .destination
                            showingOverlay.toggle()
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
                                    
                                }.frame(maxWidth: .infinity, minHeight: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                                        .fill(Color.accentColor)
                                )
                                
                                
                            }
                            //                    .padding()
                            
                            
                        }
                        .buttonStyle(OpacityChangingButton())
                        
                    }
                    //            .padding()
                    ) {
                        
                    }
                    
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
                    
                    
                    
                    if (!startingStation.isEmpty && !endingStation.isEmpty && startingStation != endingStation) {
                        Section(header: Text("Fare Details"), footer: Text("Please check the official website for group/discount ticket fares.").font(.caption2)) {
                            HStack {
                                FareListingView(fareSchedule: data.fareSchedule[startingStation]![endingStation]!)
                                
                            }
                        }
                    }
                    
                    
                    
                    Section(header: Text("Available Trains")) {
                        
                        if (queryVM.queryResultTimetable.isEmpty) {
                            HStack {
                                Spacer()
                                Text("No trains available for your selection")
                                Spacer()
                            }
                        }
                        
                        
                        List(queryVM.queryResultTimetable
                                .sorted {
                                    $0.OriginStopTime < $1.OriginStopTime
                                }
                                .filter {
                                    showAvailable ? $0.OriginStopTime.willDepartAfterNow : true
                                    
                                }
                        ) { entry in
                            //                Text(queryVM.availability[entry]?.DestinationStationName ?? "XXX")
                            PlannerResultRowView(entry: entry, availability: queryVM.availability[entry])
                            
                        }
                    }
                    
                    
                }
                if (showingOverlay) {
                    GeometryReader { geo in
                        VStack {
                            Spacer()
                            Text("\(lastPressed == .origin ? "Origin" : "Destination")").font(.title)
                            LazyVGrid(columns: columns) {
                                ForEach (data.stations) { station in
                                    Text(station.StationName.En)
                                        .font(.title3).bold()
                                        .padding(.vertical, 16)
                                        .foregroundColor(Color.white)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                                                .fill(station.StationID == (lastPressed == .origin ?  startingStation : endingStation) ? Color.accentColor : Color.secondary)
                                        )
                                        .onTapGesture {
                                            
                                            switch(lastPressed) {
                                            case .origin: startingStation = station.StationID
                                            case .destination: endingStation = station.StationID
                                                
                                            }
                                            
                                            withAnimation {
                                                showingOverlay.toggle()
                                            }
                                        }
                                    
                                }
                            }.padding()
                            Spacer()
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                        
                        .background(BlurView())
                        //                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showingOverlay.toggle()
                            }
                        }.transition(.scale)
                    }
                    
                    
                }
                
            }.navigationTitle("Planner")
            
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
