//
//  StationView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import SwiftUI

struct StationView: View {
    
    
    var station: Station
    @ObservedObject var data: HSRDataStore
    @State private var direction = 0
    
    var body: some View {
        
        List(data.stationTimetableDict[station]!) { train in
            NavigationLink(destination: TrainView(train: train)) {
                LiveBoardListView(train: train)
            }
                   
            }
                .navigationTitle(station.StationName.En)
            .onAppear(perform: {
                data.fetchTimetable(for: station, client: .init())
            })
        .listStyle(InsetGroupedListStyle())
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
