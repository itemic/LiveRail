//
//  TestingView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/17/21.
//

import SwiftUI

struct TestingView: View {
    @ObservedObject var data: HSRDataStore
    @State var selectedStation = ""
    @State var isActive = false

    var body: some View {
        
        NavigationView {
            ScrollView {
                
                ForEach(data.stations) { station in
                    Text(station.StationName.En)
                }

            }.navigationTitle("Testing")
        }
        
        
        
        
    }
}


