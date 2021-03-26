//
//  ServiceEntryViewModel.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/26/21.
//

import Foundation
import SwiftUI

class ServiceEntryViewModel: ObservableObject {
    let df = SharedDateFormatter.shared
    @Published var train: RailDailyTimetable? = nil
    @Published var stop: StopTime? = nil
    
    
}
