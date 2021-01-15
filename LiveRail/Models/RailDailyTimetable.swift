//
//  DailyTimetable.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import Foundation

struct RailODWithAvailability: Codable, Identifiable, Hashable {
    static func == (lhs: RailODWithAvailability, rhs: RailODWithAvailability) -> Bool {
        return lhs.id == rhs.id
    
    }
    
    var id: String {
        timetable.DailyTrainInfo.TrainNo
    }
    var timetable: RailODDailyTimetable
    var availability: AvailableSeatX
}

struct RailODDailyTimetable: Codable, Identifiable, Hashable {
    static func == (lhs: RailODDailyTimetable, rhs: RailODDailyTimetable) -> Bool {
        return lhs.DailyTrainInfo.TrainNo == rhs.DailyTrainInfo.TrainNo
    }
    
    
    
    var id: String {
        DailyTrainInfo.TrainNo
    }
    var TrainDate: String
    var DailyTrainInfo: DailyTrainInfo
    
    var OriginStopTime: StopTime
    var DestinationStopTime: StopTime
    
}

struct RailDailyTimetable: Codable, Hashable {
    var TrainDate: String
    var DailyTrainInfo: DailyTrainInfo
    var StopTimes: [StopTime]
}

struct DailyTrainInfo: Codable, Hashable {
    var TrainNo: String
    var Direction: Int
    var StartingStationID: String
    var StartingStationName: NameType
    var EndingStationID: String
    var EndingStationName: NameType
//    var Note: NameType? // not sure why
}

struct StopTime: Codable, Hashable {
    static func < (lhs: StopTime, rhs: StopTime) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let lhsD = dateFormatter.date(from: lhs.DepartureTime)!
        let rhsD = dateFormatter.date(from: rhs.DepartureTime)!
        
        return lhsD < rhsD
    }
    
//    var DepartureTimestamp: Date {
//        let dateFormatter
//    }
    
    
    var StopSequence: Int32
    var StationID: String
    var StationName: NameType
    var ArrivalTime: String?
    var DepartureTime: String
}
