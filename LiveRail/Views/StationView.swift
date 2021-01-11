//
//  StationView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import SwiftUI

struct StationView: View {
    
    
    var station: Station
    @ObservedObject var vm: HSRViewModel
    
    var body: some View {
        
        List(vm.stationTimetables, id: \.TrainNo) { train in
            
            LiveBoardListView(train: train)
            
                   
            }
                .navigationTitle(station.StationName.En)
            .onAppear(perform: {
                vm.fetchTimetable(for: station, client: .init())
            })
        
    }
}


//
//struct StationView_Previews: PreviewProvider {
//    static var previews: some View {
//        StationView()
//    }
//}
