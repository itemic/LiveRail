//
//  StationTimetable.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import Foundation

struct StationTimetable: Codable {
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
}
