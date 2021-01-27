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
    
    
    
    var body: some View {

        VStack {

            ForEach(data.stationTimetableDict[station]!.filter {
                (showAvailable ? true : $0.willDepartAfterNow ) &&
                    (showArrivals ? true : !$0.isTerminus)
            }) { train in
                
                TrainEntryListRowView(train: train)
//                    .padding(2)
                    .onTapGesture {
                        selectedTrain = train
                    }
                
               
                
                                
                
            }
        }
        
        .padding(.horizontal)
        

        .sheet(item: $selectedTrain) {train in
            TrainServiceView(train: train)
        }
        
        
        

        
    }
    
    

    
}

