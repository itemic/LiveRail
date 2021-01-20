//
//  StationView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import SwiftUI

struct StationTimetableView: View {
    
    
    var station: Station
    @ObservedObject var data: HSRDataStore
    
    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("hideTerminus") var hideTerminus = false
    
    @State private var selectedTrain: StationTimetable? = nil
    @State private var isShow = false
    
    var body: some View {
//        NavigationView {
//            VStack {
//                Text("CA")
//            }
        VStack {

            ForEach(data.stationTimetableDict[station]!.filter {
                (showAvailable ? $0.willDepartAfterNow : true) &&
                    (hideTerminus ? !$0.isTerminus : true)
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
