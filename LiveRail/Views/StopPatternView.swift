//
//  StopPatternView.swift
//  LiveRail
//
//  Created by Terran Kroft on 2/10/21.
//

import SwiftUI

struct StopPatternView: View {
    @StateObject var data = HSRDataStore.shared
    var daily: RailDailyTimetable
    @AppStorage("stationDotsChoice") var stationDotsChoice = 1

    var stations: [Station] {
        
        if stationDotsChoice == 1 {
            switch (daily.DailyTrainInfo.direction) {
            case .northbound: return data.stations.reversed()
            case .southbound: return data.stations
            }
        } else if stationDotsChoice == 2 {
            return data.stations
        } else if stationDotsChoice == 3 {
            return data.stations.reversed()
        } else {
            // default is (2)
            return data.stations
        }
        
        

    }
    var stoppingStations: [Station] {
        var result: [Station] = []
        for station in stations {
            for stoptime in daily.StopTimes {
                if station.StationID == stoptime.StationID {
                    result.append(station)
                }
            }
        }
        return result
    }
    var body: some View {
        HStack(spacing: 3) {
//            if stationDotsChoice == 1 {
//                switch(daily.DailyTrainInfo.direction) {
//                case .northbound:
//                    Text("$S$").font(.system(size: 8, weight: .semibold, design: .monospaced))
//                case .southbound:
//                    Text("$N$").font(.system(size: 8, weight: .semibold, design: .monospaced))
//                }
//
//            } else if stationDotsChoice == 2 {
//                Text("$N$").font(.system(size: 8, weight: .semibold, design: .monospaced))
//            } else if stationDotsChoice == 3 {
//                Text("$S$").font(.system(size: 8, weight: .semibold, design: .monospaced))
//            }
            
            ForEach(stations) { station in
                
                if (stoppingStations.contains(station)) {
                    if (station.StationID == daily.DailyTrainInfo.EndingStationID) {
                        Circle()
                            .fill(daily.DailyTrainInfo.direction.color)
                            .frame(width: 7, height: 7)
  
                        
                    } else {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 7, height: 7)
                    }
                } else {
                Circle()
                    .fill(Color.secondary)
                    .frame(width: 7, height: 7)
                }
            }
//            if stationDotsChoice == 1 {
//                switch(daily.DailyTrainInfo.direction) {
//                case .northbound:
//                    Text("$N$").font(.system(size: 8, weight: .semibold, design: .monospaced))
//                case .southbound:
//                    Text("$S$").font(.system(size: 8, weight: .semibold, design: .monospaced))
//                }
//            } else if stationDotsChoice == 2 {
//                Text("$S$").font(.system(size: 8, weight: .semibold, design: .monospaced))
//            } else if stationDotsChoice == 3 {
//                Text("$N$").font(.system(size: 8, weight: .semibold, design: .monospaced))
//            }

        }
    }
}
