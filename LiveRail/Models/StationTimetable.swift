//
//  StationTimetable.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import Foundation

struct StationTimetable: Codable, Identifiable {
    
    var id: String {
        TrainNo
    }
    
    
    var TrainDate: String
    var StationID: String
    var StationName: NameType
    var TrainNo: String
    var Direction: Int
    var StartingStationID: String
    var StartingStationName: NameType
    var EndingStationID: String
    var EndingStationName: NameType
    var ArrivalTime: String
    var DepartureTime: String
    var UpdateTime: String
    
    var isTerminus: Bool {
        StationID == EndingStationID
    }
    
    var willDepartAfterNow: Bool {
        return Date.compareNowTo(otherTime: DepartureTime)
    }
    
    var willArriveAfterNow: Bool {
        return Date.compareNowTo(otherTime: ArrivalTime)
    }
    
    var direction: TrainDirection {
        TrainDirection(fromRawValue: Direction)
    }

}
