//
//  LiveRailApp.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/9/21.
//

import SwiftUI
import Network

@main
struct LiveRailApp: App {
    @StateObject var data = HSRStore.shared
//    @AppStorage("whatsNew2-0b") var whatsNew = true
    @State private var whatsNew = true
    @StateObject var network = NetworkStatus.shared
    
    init() {
        NSTimeZone.default = TimeZone(identifier: "Asia/Taipei") ?? TimeZone.current
        data.reload(client: .init())
        
    }
    var body: some Scene {
        WindowGroup {
            PrimaryView()
                .environmentObject(network)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
                    NSTimeZone.default = TimeZone(identifier: "Asia/Taipei") ?? TimeZone.current
                    data.reload(client: .init())
                    
                }
                .onChange(of: network.connected) { status in
                    if (status == true) {
                        data.reload(client: .init())
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    print("foreground")
                    data.fetchAllAvailability(client: .init())
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    print("foreground")
                    data.fetchAllAvailability(client: .init())
                }
//                .sheet(isPresented: $whatsNew, content: {
//                    WhatsNewView()
//                })
        }
    }
}
