//
//  MainView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var data: HSRDataStore
    var body: some View {
//        TestingView(data: data)
//        TabView {
//            TestingView(data: data)
//                .tabItem {
//                    Image(systemName: "gear")
//                    Text("Testing")
//                }
//            TimetableView(data: data)
//                .tabItem {
//                    Image(systemName: "ellipsis.rectangle.fill")
//                    Text("Timetable")
//                }
            PrimaryView(data: data)
                .tabItem {
                    Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                    Text("Planner")
                }
//            SettingsView(data: data)
//                .tabItem {
//                    Image(systemName: "gearshape.fill")
//                    Text("Settings")
//                }
        }
//    }
}


