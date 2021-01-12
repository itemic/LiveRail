//
//  DailyTimetable.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import Foundation

struct RailODDailyTimetable: Codable, Identifiable {
    
    var id: String {
        OriginStopTime.DepartureTime
    }
    var TrainDate: String
    var DailyTrainInfo: DailyTrainInfo
    
    var OriginStopTime: StopTime
    var DestinationStopTime: StopTime
    
}

struct RailDailyTimetable: Codable {
    var TrainDate: String
    var DailyTrainInfo: DailyTrainInfo
    var StopTimes: [StopTime]
}

struct DailyTrainInfo: Codable {
    var TrainNo: String
    var Direction: Int
    var StartingStationID: String
    var StartingStationName: NameType
    var EndingStationID: String
    var EndingStationName: NameType
//    var Note: NameType? // not sure why
}

struct StopTime: Codable, Hashable {
//    static func > (lhs: StopTime, rhs: StopTime) {
//        return Time(lhs.DepartureTime) >
//    }
    
    var StopSequence: Int32
    var StationID: String
    var StationName: NameType
    var ArrivalTime: String?
    var DepartureTime: String
}
