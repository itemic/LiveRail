//
//  QueryResultsView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import SwiftUI

struct PlannerResultRowView: View {
    var entry: RailODDailyTimetable
    var availability: AvailableSeat?
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(entry.OriginStopTime.DepartureTime) → \(entry.DestinationStopTime.ArrivalTime)")
                        .font(.system(.headline, design: .monospaced))
                    
                    Spacer()
                }
                .foregroundColor(entry.DestinationStopTime.willDepartAfterNow ? .primary : .secondary)
                Text("Train \(entry.DailyTrainInfo.TrainNo)")
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
            }
            
            
            if (availability != nil) {
                HStack(alignment: .center) {
                    Spacer()
                    AvailabilityIconView(text: "Standard", status: availability?.standardAvailability(to: entry.DailyTrainInfo.EndingStationID) ?? .unknown)
                    AvailabilityIconView(text: "Busiess", status: availability?.businessAvailability(to: entry.DailyTrainInfo.EndingStationID) ?? .unknown)
                }
            }
            
        }
        .padding(5)
    }
   
}


