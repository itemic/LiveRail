//
//  News.swift
//  LiveRail
//
//  Created by Terran Kroft on 5/20/21.
//

import Foundation
import SwiftUI

struct NewsPost: Codable, Identifiable {
    var id: String {
        NewsID
    }
    
    var NewsID: String
    var Title: String
    var Description: String //html content idk if this breaks
    var NewsUrl: String
    var NewsCategory: String
    var StartTime: String
    
}

struct AlertInfo: Codable, Hashable {
    var Level: Int
    var Status: String
    var Title: String
    var Description: String
    var Effects: String
    var Direction: String
    var EffectedSection: String
    
    var alertStatus: AlertStatus {
        if (Status == "") {
            return .normal
        } else if (Status == "▲") {
            return .alert
        } else if (Status == "X") {
            return .suspended
        } else {
            return .alert
        }
    }
}

enum AlertStatus: Int, CaseIterable {
    case normal = 0
    case alert = 1
    case suspended = 2
    
    init(fromRawValue: Int) {
        self = AlertStatus(rawValue: fromRawValue) ?? .normal
    }
    
    var icon: String {
        switch(self) {
        case .normal: return "circle.fill"
        case .alert: return "triangle.fill"
        case .suspended: return "xmark"
        }
    }
    
    var color: Color{
        switch(self) {
        case .normal: return .green
        case .alert: return .orange
        case .suspended: return .red
        }
    }
    
    var text: String {
        switch(self) {
        case .normal: return "NORMAL_STATUS"
        case .alert: return "ALERT_STATUS"
        case .suspended: return "SUSPENDED_STATUS"
        }
    }
    
}
