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
            ZStack {
                
                //MARK First part
                ScrollView {
                    Button(action: {
                        isActive = true
                    }) {
                        Text("Button")
                    }
                    .buttonStyle(CustomButtonStyle())
                    VStack {

                    ForEach(1..<100) { _ in
                        HStack {
                        Text("Hey")
                            Spacer()
                        }
                    }
                        Spacer()
                    }.padding()


                    
                }
                
                //MARK Second part
                StationButtonPickerView(title: "Origin", stations: data.stations, selectedStation: $selectedStation, isActive: $isActive)

            }.navigationTitle("Testing")
        }
        
        
        
        
    }
}


