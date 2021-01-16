//
//  MoreView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/13/21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var data: HSRDataStore
    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("hideTerminus") var hideTerminus = false
    @AppStorage("showNearestStation") var showNearestStation = true
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("Nearest station requires location services turned on.")) {
                    Text("Last updated: \(data.lastUpdateDate)")
                    Toggle("Hide departed services", isOn: $showAvailable)
                    Toggle("Hide terminus services", isOn: $hideTerminus)
                    Toggle("Show nearest station", isOn: $showNearestStation)
                }
            }.navigationBarTitle("Settings")
        }
    }
}
//
//struct MoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoreView()
//    }
//}
