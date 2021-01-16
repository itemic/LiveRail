//
//  NearestStationView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/15/21.
//

import SwiftUI

struct NearestStationView: View {
    var station: Station?
    @ObservedObject var data: HSRDataStore
    var direction: TrainDirection
    
    var firstNth: StationTimetable? {
        if let station = station {
            return data.stationTimetableDict[station]?.first {
                $0.direction == .northbound &&
                    $0.willDepartAfterNow
                    && !$0.isTerminus
                
            }
        }
        return nil
    }
    
    var firstSth: StationTimetable? {
        if let station = station {
            return data.stationTimetableDict[station]?.first {
                $0.direction == .southbound &&
                    $0.willDepartAfterNow
                    && !$0.isTerminus
                
            }
        }
        return nil
    }
    
    var firstTrain: StationTimetable? {
        switch (direction) {
        case .southbound: return firstSth
        case .northbound: return firstNth
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            //            Text(station?.StationName.En.uppercased() ?? "--").font(.headline)
            
            
            
            
            if (firstTrain != nil) {
                
                NavigationLink(destination: TrainView(train: firstTrain!)) {
                    TrainEntryListRowView(train: firstTrain!)
                }
            }
            
            
        }
        .listRowBackground(Color(UIColor.systemGroupedBackground))
    }
    
}
