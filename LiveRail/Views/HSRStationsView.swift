//
//  ContentView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/9/21.
//

import SwiftUI

struct HSRStationsView: View {
//    @ObservedObject private var vm = HSRViewModel(client: .init())
    @ObservedObject var data: HSRDataStore
    var body: some View {
        NavigationView {
        List(data.stations) { station in
            NavigationLink(destination: StationView(station: station, data: data)) {
                VStack(alignment: .leading) {
                    Text("\(station.StationName.En)").bold()
                    Text("\(station.StationName.Zh_tw)")
                }
            }
        }.listStyle(InsetGroupedListStyle())
        .navigationTitle("Stations")
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
