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
        TabView {
            HSRStationsView(data: data)
                .tabItem {
                    Image(systemName: "ellipsis.rectangle")
                    Text("Timetable")
                }
            PlannerHomeView(data: data)
                .tabItem {
                    Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                    Text("Planner")
                }
        }
    }
}


