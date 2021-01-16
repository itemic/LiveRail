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
    @State private var direction = 0
    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("hideTerminus") var hideTerminus = false
    
    var body: some View {
        List {
            ForEach(data.stationTimetableDict[station]!.filter {
                (showAvailable ? $0.willDepartAfterNow : true) &&
                    (hideTerminus ? !$0.isTerminus : true)
            }) { train in
                NavigationLink(destination: TrainView(train: train)) {
                    TrainEntryListRowView(train: train)
                }.listRowBackground(Color(UIColor.systemGroupedBackground)) 
                
            }
        }
        .navigationTitle(station.StationName.En)
        .onAppear(perform: {
            data.fetchTimetable(for: station, client: .init())
        })
        .listStyle(InsetGroupedListStyle())
        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
        }
        .animation(.default)
        
    }
    

    
}


//
//struct StationView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationView()
//    }
//}
