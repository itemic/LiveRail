//
//  DailyTimetable.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import Foundation



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
    
    func isStarting(stop: StopTime) -> Bool {
        return stop.StationID == DailyTrainInfo.StartingStationID
    }
    
    func isEnding(stop: StopTime) -> Bool {
        return stop.StationID == DailyTrainInfo.EndingStationID
    }
    
    func isTrainAtStation(stop: StopTime) -> Bool {
        return !stop.willArriveAfterNow && stop.willDepartAfterNow
    }
    
}

struct DailyTrainInfo: Codable, Hashable {
    var TrainNo: String
    var Direction: Int
    var StartingStationID: String
    var StartingStationName: NameType
    var EndingStationID: String
    var EndingStationName: NameType

    
    var direction: TrainDirection {
        TrainDirection(fromRawValue: Direction)
    }
}

struct StopTime: Codable, Hashable {
    static func < (lhs: StopTime, rhs: StopTime) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let lhsD = dateFormatter.date(from: lhs.DepartureTime)!
        let rhsD = dateFormatter.date(from: rhs.DepartureTime)!
        
        return lhsD < rhsD
    }
    var StopSequence: Int
    var StationID: String
    var StationName: NameType
    var ArrivalTime: String
    var DepartureTime: String
    
    var willDepartAfterNow: Bool {
        return Date.compareNowTo(otherTime: DepartureTime)
    }
    
    var willArriveAfterNow: Bool {
        return Date.compareNowTo(otherTime: ArrivalTime)
    }
    
    
}
