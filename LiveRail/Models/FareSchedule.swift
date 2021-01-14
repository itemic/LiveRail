//
//  FareSchedule.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/14/21.
//

import Foundation
import SwiftUI

struct FareSchedule: Codable {
    var OriginStationID: String
    var OriginStationName: NameType
    var DestinationStationID: String
    var DestinationStationName: NameType
    
    var Direction: Int
    var Fares: [Fare]
    
    func fare(for type: FareClass) -> Int {
        return Fares.first {
            $0.ticketType == type
        }?.Price ?? 0
    }
    
}

struct Fare: Codable {
    
  
    var TicketType: String
    var Price: Int
    
    var ticketType: FareClass {
        switch (TicketType) {
        case "商務":
            return .business
        case "標準":
            return .reserved
        case "自由":
            return .nonreserved
        default:
            return .reserved
            
        }
    }
}

enum FareClass: String, CaseIterable {
    case reserved
    case nonreserved
    case business
    
    func color() -> Color {
        switch(self) {
        case .reserved: return .orange
        case .business: return .purple
        case .nonreserved: return .green
        }
    }
    
    func text() -> String {
        switch(self) {
        case .reserved: return "Reserved"
        case .business: return "Business"
        case .nonreserved: return "Nonrsrvd"
        }
    }
}
