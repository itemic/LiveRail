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
    @State var timetableStation = ""
    @AppStorage("showAvailable") var showAvailable = false
    
    @State private var originIsActive = false
    @State private var destinationIsActive = false
    @State private var timetableIsActive = false
    
    @State private var rotationAmount = 0.0
    
    @State private var showingSettings = false
    @State private var currentView: HSRViews = .plannerView
    
    @State private var showingTimetable: StationTimetable?
    
    @StateObject var lm = LocationManager.shared
    var nextUp: String {
        return lm.closestStation(stations: data.stations)?.StationName.En ?? "N/A"
    }
    
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
    
    var PlannerView: some View {
        ZStack {
            //MARK: ONE
            VStack {
                Spacer()
                    .frame(height: 75)
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            if (!startingStation.isEmpty && !endingStation.isEmpty && startingStation != endingStation) {
                                FareListingView(fareSchedule: data.fareSchedule[startingStation]![endingStation]!)
                            }
                        }
                        .padding(.vertical)
                        
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
                        Spacer()
                            .frame(height: 110)
                    }
                    .padding(.horizontal)
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
                        //                    .padding()
                        
                        
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
                    //                .buttonStyle(CustomButtonStyle())
                    
                    
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
            
            
            
            //                .padding()
        }
        
    }
    
    var TimetableView: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 75)
                ScrollView {
                    if (data.station(from: timetableStation) != nil) {
                        
                        
                        StationTimetableView(station: data.station(from: timetableStation)!, data: data)
                        
                        
                        
                    }
                }
            }
            
            VStack {
                
                
                Spacer()
                HStack {
                    Button(action: {
                        withAnimation {
                            timetableIsActive = true
                        }
                    }) {
                        VStack {
                            
                            VStack {
                                Text(data.stationName(from: timetableStation))
                                    .foregroundColor(.white)
                                    .font(.title2).bold()
                            }.frame(maxWidth: .infinity, minHeight: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(Color.purple)
                            )
                        }
                    }
                    .buttonStyle(OpacityChangingButton())
                    
                    
                    if let status = lm.status {
                        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
                    Button(action: {
                        if let nearest = lm.closestStation(stations: data.stations)?.StationID {
                            timetableStation = nearest
                        }
                    }) {
                        VStack {

                            VStack {
                                Image(systemName: "location.fill")
                                    .font(.system(.title2))
                                    .foregroundColor(.white)

                            }.frame(maxWidth: 60, minHeight: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(Color.purple)
                            )
                        }
                    }
                    .buttonStyle(OpacityChangingButton())
                    }
                    }
                    
                    
                }
                .padding()
                .padding(.bottom, 15)
                .background(BlurView())
                
                
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    var body: some View {
        
        ZStack {
            
            if (currentView == .plannerView) {
                PlannerView
            } else {
                TimetableView
            }
            
            
            //MARK: 1.5
            VStack {
                VStack {
                    Spacer()
                        .frame(height: 55)
                    VStack {
                        HStack {
                            Text("Rail \(currentView.string)").font(.title).bold()
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    switch(currentView) {
                                    case .plannerView:
                                        currentView = .timetableView
                                    case .timetableView:
                                        currentView = .plannerView
                                    }
                                }
                            }) {
                                Image(systemName: "list.bullet.below.rectangle").imageScale(.large).foregroundColor(.accentColor)
                                    .padding(5)
                                    .background(Color.accentColor.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            
                            Button(action: {
                                showingSettings = true
                            }) {
                                Image(systemName: "gearshape.fill").imageScale(.large).foregroundColor(.accentColor)
                                    .padding(5)
                                    .background(Color.accentColor.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            .sheet(isPresented: $showingSettings) {
                                SettingsView(data: data)
                            }
                            
                        }
                    }
                }
                .padding()
                .background(BlurView())
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            
            //MARK: 2
            ZStack {
                StationButtonPickerView(title: "Origin", stations: data.stations, selectedStation: $startingStation, isActive: $originIsActive)
                    .edgesIgnoringSafeArea(.all)
                StationButtonPickerView(title: "Destination", stations: data.stations, selectedStation: $endingStation, isActive: $destinationIsActive)
                    .edgesIgnoringSafeArea(.all)
                StationButtonPickerView(title: "View Timetable", stations: data.stations, selectedStation: $timetableStation, isActive: $timetableIsActive)
                    .edgesIgnoringSafeArea(.all)
            }.onChange(of: startingStation) { newValue in
                if (!newValue.isEmpty && !endingStation.isEmpty) {
                    queryVM.fetchQueryTimetables(from: startingStation, to: endingStation, client: .init())
                    sendHaptics()
                }
            }
            .onChange(of: endingStation) { newValue in
                if (!newValue.isEmpty && !startingStation.isEmpty) {
                    queryVM.fetchQueryTimetables(from: startingStation, to: endingStation, client: .init())
                    sendHaptics()
                }
            }
            
            
        }
        
        
        
        
        
    }
    
    func sendHaptics() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
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

enum HSRViews: String, CaseIterable {
    case plannerView, timetableView
    
    var string: String {
        switch(self) {
        case .plannerView:   return "Planner"
        case .timetableView: return "Timetable"
        }
    }
}
