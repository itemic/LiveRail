//
//  PlannerHomeView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import SwiftUI

struct PlannerHomeView: View {
    @ObservedObject var data: HSRDataStore
    // stored as IDs 4-digit string
    @State var startingStation = ""
    @State var endingStation = ""
    @AppStorage("showAvailable") var showAvailable = false
    @State var showingOverlay = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @ObservedObject var queryVM = HSRQueryViewModel()
    var body: some View {
        NavigationView {
            ZStack {
        Form {
            Section {
                
//                HStack {
//                    Text("A")
//                        .padding()
//                        .background(Color.blue)
//                        .onTapGesture {
//                            showingOverlay.toggle()
//                        }
//                    Spacer()
//                    Text("A")
//                        .padding()
//                        .background(Color.blue)
//                }
                
                Picker(selection: $startingStation, label: Text("Origin")) {
                    ForEach(data.stations) {
                        Text("\($0.StationName.En)").tag($0.StationID)
                    }
                }
                

                Picker(selection: $endingStation, label: Text("Destination")) {
                    ForEach(data.stations) {
                        Text("\($0.StationName.En)").tag($0.StationID)
                        
                    }
                }
                
                
                Button("Flip origin and destination") {
                    let temp = startingStation
                    startingStation = endingStation
                    endingStation = temp
                }
                

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
                            FareView(fareSchedule: data.fareSchedule[startingStation]![endingStation]!)
                            
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
                showAvailable ? compareTime(otherTime: $0.OriginStopTime.DepartureTime) : true

            }
            ) { entry in
//                Text(queryVM.availability[entry]?.DestinationStationName ?? "XXX")
                QueryResultsCardView(entry: entry, availability: queryVM.availability[entry])
                
            }
            }
            
            
        }
                if (showingOverlay) {
                    GeometryReader { geo in
                        VStack {
                            LazyVGrid(columns: columns) {
                                ForEach (data.stations) { station in
                                    Text(station.StationName.En)
                                        .font(.headline)
                                        .padding(.vertical, 16)
                                        .foregroundColor(Color.white)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                                                .fill(station.StationID == startingStation ? Color.accentColor : Color.secondary)
                                            )
                                        .onTapGesture {
                                            startingStation = station.StationID
                                            withAnimation {
                                            showingOverlay.toggle()
                                            }
                                        }
                                        
                                }
                            }.padding()
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                        .background(BlurView())
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
    func compareTime(otherTime: String) -> Bool {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let departure = dateFormatter.date(from: otherTime) else { return false }
        return now.time < departure.time
        
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
