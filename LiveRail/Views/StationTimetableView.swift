//
//  StationView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import SwiftUI

struct StationTimetableView: View {
    
    
    var station: Station
    @StateObject var data = HSRDataStore.shared

    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("showArrivals") var showArrivals = false
    
    @State private var selectedTrain: StationTimetable? = nil
    @State private var isShow = false
    
    @State private var presented: Bool = false
    
    var body: some View {

        VStack {

            ForEach(data.stationTimetableDict[station]!.filter {
                (showAvailable ? true : $0.willDepartAfterNow ) &&
                    (showArrivals ? true : !$0.isTerminus)
            }) { train in
                
                Button(action: {
                    selectedTrain = train
                    presented = true
                    
                }, label: {
                    TrainEntryListRowView(train: train)
                    
                })
                
                .padding(2)
                
                
                
            }
        }
        
        .padding()
        
//        .sheet(isPresented: $presented, content: {
//            if let selectedTrain = selectedTrain {
//            TrainServiceView(train: selectedTrain)
//            }
//        })
////
        .sheet(item: $selectedTrain) {train in
            TrainServiceView(train: train)
        }
        
        
        

        
    }
    
    

    
}

