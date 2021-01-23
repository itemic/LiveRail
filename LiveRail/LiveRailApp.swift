//
//  LiveRailApp.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/9/21.
//

import SwiftUI

@main
struct LiveRailApp: App {
    @StateObject var data = HSRDataStore.shared
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
