//
//  StationTimetableViewModel.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/30/21.
//

import Foundation
import SwiftUI

final class StationTimetableViewModel: ObservableObject {
    let data = HSRStore.shared
    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("showArrivals") var showArrivals = false
    
    @Published var station: Station? = nil
//    @Published var filteredDepartures: [RailDailyTimetable] = []
    
//    var filteredDepartures: [RailDailyTimetable] {
////        guard let station = station else {return []}
//        if let station = station {
//        return data.getDepartures(from: station.StationID).filter {
//            (showArrivals ? true : !isEndingTerminus(for: $0, at: station)) &&
//                (showAvailable ? true : getTrainWillDepartAfterNow(for: $0, at: station))
//        }
//        } else {
//            return []
//        }
//    }
    
    var departures: [RailDailyTimetable] {
        guard let station = station else {return []}
        return data.getDepartures(from: station.StationID)
    }
    
    func getArrivalTime(for train: RailDailyTimetable, at station: Station) -> String {
        return train.StopTimes.first(where: {
            $0.StationID == station.StationID
        })!.ArrivalTime
    }
    
    func getDepartureTime(for train: RailDailyTimetable, at station: Station) -> String {
        return train.StopTimes.first(where: {
            $0.StationID == station.StationID
        })?.DepartureTime ?? "--:--"
    }
    
    // train has not departed
    func getTrainWillDepartAfterNow(for train: RailDailyTimetable, at station: Station) -> Bool {
        return Date.compare(to: getDepartureTime(for: train, at: station))
    }
    
    // train has not arrived
    func getTrainWillArriveAfterNow(for train: RailDailyTimetable, at station: Station) -> Bool {
        return Date.compare(to: getArrivalTime(for: train, at: station))
    }
    
    func getTrainIsDepartingSoon(for train: RailDailyTimetable, at station: Station) -> Bool {
        //TODO update to show train departing within 5 minutes
        // move out of model here
        
        return getTrainWillDepartAfterNow(for: train, at: station) && !getTrainWillArriveAfterNow(for: train, at: station)
    }
    
    func isEndingTerminus(for train: RailDailyTimetable, at station: Station) -> Bool {
        return train.DailyTrainInfo.EndingStationID == station.StationID
    }
    
    func isStartingTerminus(for train: RailDailyTimetable, at station: Station) -> Bool {
        return train.DailyTrainInfo.StartingStationID == station.StationID
    }
    
    func isTerminus(for train: RailDailyTimetable, at station: Station) -> Bool {
        return isEndingTerminus(for: train, at: station) || isStartingTerminus(for: train, at: station)
    }
    
    
}
