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
    @State var showAvailable = true
    
    @ObservedObject var queryVM = HSRQueryViewModel()
    var body: some View {
        NavigationView {
        Form {
            Section {
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

            }
            
            Toggle(isOn: $showAvailable) {
                Text("Hide departed trains")
            }
            
            Section {
                
                
                    Button("Find trains") {
                        queryVM.fetchQueryTimetables(from: startingStation, to: endingStation, client: .init())
                    }.disabled(startingStation.isEmpty || endingStation.isEmpty)
                
            
            }
            
            List(queryVM.queryResultTimetable) { entry in
                VStack {
                    HStack {
                        Text(entry.DailyTrainInfo.TrainNo).bold()
                        Spacer()
                    }
                    HStack {
                        VStack {
                        Text(entry.OriginStopTime.StationName.En)
                        Text(entry.OriginStopTime.DepartureTime)
                        }
                        Spacer()
                        VStack {
                        Text(entry.DestinationStopTime.StationName.En)
                        Text(entry.DestinationStopTime.ArrivalTime ?? entry.DestinationStopTime.DepartureTime)
                        }
                    }
                }
            }
        }.navigationTitle("Planner")
        }
    }
}
