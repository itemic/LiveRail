//
//  SeatAvailability.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import Foundation

struct AvailableSeatStatus: Codable {
//    var UpdateTime: String
//    var UpdateInterval: String
//    var SrcUpdateTime: String
//    var SrcUpdateInterval: String
    var Count: Int?
    var TrainDate: String
    var AvailableSeats: [AvailableSeat]
}

struct AvailableSeat: Codable, Hashable {
    var TrainNo: String
    var Direction: Int
    var OriginStationID: String
    var OriginStationName: NameType
    var OriginStationCode: String
    var DestinationStationID: String
    var DestinationStationName: NameType
    var DestinationStationCode: String
    var StandardSeatStatus: String
    var BusinessSeatStatus: String
    
    var standardAvailability: SeatAvailability {
        switch StandardSeatStatus {
        case "O":
            return .available
        case "L":
            return .limited
        case "X":
            return .unavailable
        default:
            return .unknown
        }
    }
    
    var businessAvailability: SeatAvailability {
        switch BusinessSeatStatus {
        case "O":
            return .available
        case "L":
            return .limited
        case "X":
            return .unavailable
        default:
            return .unknown
        }
    }
}

enum SeatAvailability: String, CaseIterable {
    case available, limited, unavailable, unknown
    
    func text() -> String {
        switch self {
        case .available: return "available"
        case .limited: return "limited"
        case .unknown: return "unknown"
        case .unavailable: return "unavailable"
        }
    }
    
}
