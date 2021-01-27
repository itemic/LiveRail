//
//  ENums.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/16/21.
//

import Foundation
import SwiftUI

enum TrainDirection: Int, CaseIterable {
    case southbound = 0
    case northbound = 1
    
    init(fromRawValue: Int) {
        self = TrainDirection(rawValue: fromRawValue) ?? .southbound
    }
    
    var abbreviated: String {
        switch(self) {
        case .southbound: return "S"
        case .northbound: return "N"
        }
    }
    
    var spelledOut: String {
        switch(self) {
        case .southbound: return "Southbound"
        case .northbound: return "Northbound"
        }
    }
    
    var color: Color {
        switch(self) {
        case .southbound: return .green
        case .northbound: return .blue
        }
    }
    
    
}
