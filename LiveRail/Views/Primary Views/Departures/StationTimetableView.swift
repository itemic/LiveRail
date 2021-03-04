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
    @StateObject var data2 = HSRStore.shared

    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("showArrivals") var showArrivals = false
    
    @Binding var selectedTrain: StationTimetable?
    @Binding var isShow: Bool
    
    
    
    var body: some View {
        ZStack {
        VStack {
            
//            TEST MODE
            ForEach(data2.getDepartures(from: station.StationID)) { departure in
                Text(departure.DailyTrainInfo.TrainNo)
            }
//            END TEST MODE

            ForEach(data.stationTimetableDict[station]!.filter {
                (showAvailable ? true : $0.willDepartAfterNow ) &&
                    (showArrivals ? true : !$0.isTerminus)
            }) { train in
                
                TrainEntryListRowView(train: train)
//                    .padding(2)
                    .onTapGesture {
                        selectedTrain = train
                        isShow = true
                    }
                
               
                
                                
                
            }
        }
        
        .padding(.horizontal)
        

//        .sheet(item: $selectedTrain) {train in
//            TrainServiceView(train: train)
//        }
        
            // stack it up here
            
            
        }
        

        
    }
    
    

    
}

