//
//  NearestStationView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/15/21.
//

import SwiftUI

struct NearestStationView: View {
    var station: Station?
    @StateObject var data = HSRDataStore.shared
    var direction: TrainDirection
    var entries: Int
   
    
    var firstTrain: StationTimetable? {
        if let station = station {
            return data.stationTimetableDict[station]?.first {
                $0.direction == direction &&
                    $0.willDepartAfterNow
                    && !$0.isTerminus
                
            }
        }
        return nil
    }
    
    var upcomingTrains: [StationTimetable] {
        if let station = station {
                let slice = data.stationTimetableDict[station]?.filter {$0.direction == direction && $0.willDepartAfterNow && !$0.isTerminus} ?? []
            return Array(slice.prefix(entries))
        }
        return []
        
    }
    
    
    
    var body: some View {

        ForEach(upcomingTrains) { train in
            
                VStack {
                    NavigationLink(destination: TrainServiceView(train: train)) {
                        TrainEntryListRowView(train: train)
                    }
                }.listRowBackground(Color(UIColor.systemGroupedBackground))
            
        }
    }
    
}
