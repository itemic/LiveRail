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
//        NavigationView {
//            VStack {
//                Text("CA")
//            }
        VStack {

            ForEach(data.stationTimetableDict[station]!.filter {
                (showAvailable ? true : $0.willDepartAfterNow ) &&
                    (showArrivals ? true : !$0.isTerminus)
            }) { train in
                
                Button(action: {
                    selectedTrain = train
                }, label: {
                    TrainEntryListRowView(train: train)
                    
                })
                .padding(2)
                
                
            }
        }
        .padding()
        .sheet(item: $selectedTrain, content: {train in
            TrainServiceView(train: train)
        })
//        }
        
        

        
    }
    

    
}


//
//struct StationView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationView()
//    }
//}
