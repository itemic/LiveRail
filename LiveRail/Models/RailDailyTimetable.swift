//
//  DailyTimetable.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import Foundation



struct RailDailyTimetable: Codable, Hashable, Identifiable {
    
    var id: String {
        DailyTrainInfo.TrainNo
    }
    
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

    
    var direction: TrainDirection {
        TrainDirection(fromRawValue: Direction)
    }
}

struct StopTime: Codable, Hashable {
    static func < (lhs: StopTime, rhs: StopTime) -> Bool {
        let lhsD = SharedDateFormatter.shared.date(from: lhs.DepartureTime)!
        let rhsD = SharedDateFormatter.shared.date(from: rhs.DepartureTime)!
        
        return lhsD < rhsD
    }
    var StopSequence: Int
    var StationID: String
    var StationName: NameType
    var ArrivalTime: String
    var DepartureTime: String


    
}
