//
//  SeatAvailability2.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/15/21.
//
import SwiftUI
import Foundation

struct AvailabilityWrapper: Codable {
    var UpdateTime: String
    var Count: Int?
    var AvailableSeats: [AvailableSeat]
}

struct AvailableSeat: Codable {
    var TrainNo: String
    var Direction: Int
    var StationID: String
    var StationName: NameType
    var DepartureTime: String
    var EndingStationID: String
    var EndingStationName: NameType
    var StopStations: [AvailabilityStopStation]
//    var SrcRecTime: String
//    var UpdateTime: String
    
    
    // ADDITIONAL COMPUTED PROPERTIES
    
    func standardAvailability(to station: String) -> SeatAvailability {
        return StopStations.first {
            $0.StationID == station
        }?.standardAvailability ?? .unknown
    }
    
    func businessAvailability(to station: String) -> SeatAvailability {
        return StopStations.first {
            $0.StationID == station
        }?.businessAvailability ?? .unknown
        
        
    }
    
    var direction: TrainDirection {
        TrainDirection(fromRawValue: Direction)
    }
}
struct AvailabilityStopStation: Codable {
    var StopSequence: Int
    var StationID: String
    var StationName: NameType
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
    
    func icon() -> Image {
        switch self {
        case .available: return Image(systemName: "circle.fill")
        case .limited: return Image(systemName: "triangle.fill")
        case .unavailable: return Image(systemName: "xmark")
        case .unknown: return Image(systemName: "questionmark")
        }
    }
    
    func color() -> Color {
        switch self {
        case .available: return .green
        case .limited: return .orange
        case .unavailable: return .red
        case .unknown: return .gray
        }
    }
    
}

