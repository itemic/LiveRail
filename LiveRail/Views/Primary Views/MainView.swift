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

            PrimaryView(data: data)

        }

}


