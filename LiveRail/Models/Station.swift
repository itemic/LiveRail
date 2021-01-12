//
//  Station.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/9/21.
//

import Foundation

struct Station: Codable, Identifiable {
    
    var id: String {
        StationID
    }
    var StationID: String
    var StationName: NameType
    var StationCode: String
    
//    enum CodingKeys: String, CodingKey {
//        case stationID = "StationID"
//        case stationName = "StationName"
//        case stationCode = "StationCode"
//    }
}

struct NameType: Codable {
    var Zh_tw: String
    var En: String
    
//    enum CodingKeys: String, CodingKey {
//        case zhTw = "Zh_tw"
//        case en = "En"
//    }
}
