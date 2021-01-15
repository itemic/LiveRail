//
//  Station.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/9/21.
//

import Foundation
import CoreLocation

struct Station: Codable, Identifiable, Hashable {
    static func == (lhs: Station, rhs: Station) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    var id: String {
        StationID
    }
    var StationID: String
    var StationName: NameType
    var StationCode: String
    var StationPosition: PointType
    var coordinates: CLLocation {
        return CLLocation(latitude: StationPosition.PositionLat, longitude: StationPosition.PositionLon)
    }
}

struct NameType: Codable, Hashable {
    var Zh_tw: String
    var En: String
    
//    enum CodingKeys: String, CodingKey {
//        case zhTw = "Zh_tw"
//        case en = "En"
//    }
}

struct PointType: Codable, Hashable {
    var PositionLat: Double
    var PositionLon: Double
}
