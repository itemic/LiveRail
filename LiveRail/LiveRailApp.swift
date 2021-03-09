//
//  LiveRailApp.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/9/21.
//

import SwiftUI

@main
struct LiveRailApp: App {
    @StateObject var data = HSRStore.shared
    
    init() {
        print("WAHOO")
        NSTimeZone.default = TimeZone(identifier: "Asia/Taipei") ?? TimeZone.current
    }
    var body: some Scene {
        WindowGroup {
            MainView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
                    NSTimeZone.default = TimeZone(identifier: "Asia/Taipei") ?? TimeZone.current
                    data.reload(client: .init())
                    
                }
        }
    }
}
