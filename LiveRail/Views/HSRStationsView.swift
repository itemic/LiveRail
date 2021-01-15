//
//  ContentView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/9/21.
//

// source for some stuff: https://adrianhall.github.io/swift/2019/11/05/swiftui-location/

import SwiftUI
import CoreLocation

struct HSRStationsView: View {
    @StateObject var lm = LocationManager.shared
    @ObservedObject var data: HSRDataStore
//    let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    @AppStorage("showNearestStation") var showNearestStation = true
    
    var nextUp: String {
        return lm.closestStation(stations: data.stations)?.StationName.En ?? "N/A"
    }
    
    
    


    
    var body: some View {
        NavigationView {
        
            List {
                
                if (showNearestStation) {
                if let status = lm.status {
                    if (status == .authorizedAlways || status == .authorizedWhenInUse) {
                        Section(header: Text("Nearest station: \(nextUp)") , footer: NearestStationView(station: lm.closestStation(stations: data.stations), data: data)
                                    .foregroundColor(.primary)) {
                        }
                    } else  {
                        Section(header: Text("Nearest station") , footer: RequestLocationView(lm: lm)) {
                            
                        }
                    }
                }
                }
                 
                
                
                Section(header: Text("All stations")) {
            ForEach(data.stations) { station in
            NavigationLink(destination: StationView(station: station, data: data)) {
                VStack(alignment: .leading) {
                    Text("\(station.StationName.En)").bold()
                    Text("\(station.StationName.Zh_tw)")
                }
            }
        }
                }
        }.listStyle(InsetGroupedListStyle())
            .onChange(of: lm.isActive, perform: {loc in
                print(loc)
            })
        .navigationTitle("Stations")
            
        }
//        .onReceive(timer) { time in
//            if (lm)
//        }
//     

        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
