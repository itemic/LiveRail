//
//  MainView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HSRStationsView()
                .tabItem {
                    Image(systemName: "ellipsis.rectangle")
                    Text("Live Board")
                }
            PlannerHomeView()
                .tabItem {
                    Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                    Text("Planner")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
