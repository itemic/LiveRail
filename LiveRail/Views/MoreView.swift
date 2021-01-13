//
//  MoreView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/13/21.
//

import SwiftUI

struct MoreView: View {
    @ObservedObject var data: HSRDataStore
    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("hideTerminus") var hideTerminus = false
    var body: some View {
        NavigationView {
            Form {
                Toggle("Hide departed services", isOn: $showAvailable)
                Toggle("Hide terminus services", isOn: $hideTerminus)
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
