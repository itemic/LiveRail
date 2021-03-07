//
//  PlanTimetableView.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/6/21.
//

import SwiftUI

struct PlanTimetableView: View {
    @StateObject var data = HSRStore.shared
    @AppStorage("showAvailable") var showAvailable = false
    var origin: Station?
    var destination: Station?
    @Binding var isShow: Bool

    @Binding var selectedTimetable: RailDailyTimetable?
    
    
    var body: some View {
        VStack {
            
            ForEach(data.getDeparturesWith(from: origin!, to: destination!)
                        .filter {
                            (showAvailable ? true : data.getTrainWillDepartAfterNow(for: $0, at: origin!))
                        }) { entry in
                PlannerResultRowView(entry: entry, availability: data.getAvailability(for: entry.DailyTrainInfo.TrainNo, from: origin!), origin: origin!, destination: destination!)
                    .onTapGesture {
                        selectedTimetable = entry
                        isShow = true
                    }
            }
            
        }
        .padding(.horizontal)
    }
}

