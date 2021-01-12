//
//  QueryResultsView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import SwiftUI

struct QueryResultsCardView: View {
    var entry: RailODDailyTimetable
    var availability: AvailableSeat?
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            HStack {
                Text("\(entry.OriginStopTime.DepartureTime) → \(entry.DestinationStopTime.ArrivalTime ?? entry.DestinationStopTime.DepartureTime)")
                    .font(.system(.headline, design: .monospaced))
                    
                Spacer()
            }
            .foregroundColor(compareTime(otherTime: entry.DestinationStopTime.DepartureTime) ? .primary : .secondary)
            Text("Train \(entry.DailyTrainInfo.TrainNo)")
                .font(.subheadline)
                .foregroundColor(.accentColor)
            
            
            
            if (availability != nil) {
                Spacer()
                Text("Reserved seats \(availability?.standardAvailability.text() ?? "unknown") | Business seats \(availability?.businessAvailability.text() ?? "unknown")").font(.caption2).foregroundColor(.secondary)
            }

        }
        .padding(5)
    }
    
    func compareTime(otherTime: String) -> Bool {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let departure = dateFormatter.date(from: otherTime) else { return false }
        return now.time < departure.time
        
    }
}


