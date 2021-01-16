//
//  ContentView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/9/21.
//

// source for some stuff: https://adrianhall.github.io/swift/2019/11/05/swiftui-location/

import SwiftUI
import CoreLocation

struct TimetableView: View {
    @StateObject var lm = LocationManager.shared
    @ObservedObject var data: HSRDataStore
    @AppStorage("showNearestStation") var showNearestStation = true
    @AppStorage("nextDepartureEntries") var nextDepartureEntries = 1
    
    var nextUp: String {
        return lm.closestStation(stations: data.stations)?.StationName.En ?? "N/A"
    }
        
    var body: some View {
        NavigationView {
        
            List {
                
                if (showNearestStation) {
                if let status = lm.status {
                    if (status == .authorizedAlways || status == .authorizedWhenInUse) {
                        Section(header: Text("Next departures from \(nextUp)")) {
                            NearestStationView(station: lm.closestStation(stations: data.stations), data: data, direction: .northbound, entries: nextDepartureEntries)
                            NearestStationView(station: lm.closestStation(stations: data.stations), data: data, direction: .southbound, entries: nextDepartureEntries)
                        }
                        
                    } else  {
                        Section(header: Text("Next Departures") , footer: RequestLocationView(lm: lm)) {
                            
                        }
                    }
                }
                }
                 
                
                
                Section(header: Text("All stations")) {
            ForEach(data.stations) { station in
            NavigationLink(destination: StationTimetableView(station: station, data: data)) {
                VStack(alignment: .leading) {
                    Text("\(station.StationName.En)").bold()
                    Text("\(station.StationName.Zh_tw)")
                }
            }
        }
                }
        }
            .listStyle(InsetGroupedListStyle())
//            .listStyle(GroupedListStyle())
            
        .navigationTitle("Stations")
            
        }

    }
}