//
//  QueryResultsView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import SwiftUI

struct PlannerResultRowView: View {
    @StateObject var data = HSRStore.shared
    var entry: RailDailyTimetable
    var availability: AvailableSeat?
    
    var origin: Station
    var destination: Station
    
    var stations: [Station] {
        switch (entry.DailyTrainInfo.direction) {
        case .northbound: return data.stations.reversed()
        case .southbound: return data.stations
        }
    }
    
    var body: some View {
        
        
        
        HStack {
            //            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("\(entry.DailyTrainInfo.TrainNo)").font(Font.system(.headline).monospacedDigit().weight(.semibold))
                    Spacer()
                    if (!data.getTrainWillDepartAfterNow(for: entry, at: origin)) {
                        Text("DEPARTED")
                            .font(Font.system(.subheadline))
                            .foregroundColor(.red)
                            .padding(4)
                            .background(Color.red.opacity(0.2))
                            .cornerRadius(5)
                    }
//                    else {
                        AvailabilityIconView(text: "Standard", status: availability?.standardAvailability(to: entry.DailyTrainInfo.EndingStationID) ?? .unknown)
                        AvailabilityIconView(text: "Business", status: availability?.businessAvailability(to: entry.DailyTrainInfo.EndingStationID) ?? .unknown)
//                    }
                    
                }
                .padding(.horizontal, 5)
                HStack {
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey(data.getStopTime(for: origin, on: entry).StationName.En)).foregroundColor(.secondary).font(Font.system(.caption))
                        Text("\(data.getStopTime(for: origin, on: entry).DepartureTime)").font(Font.system(.title).monospacedDigit().weight(.semibold))
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("").foregroundColor(.secondary).font(Font.system(.caption))
                        Text("→").font(Font.system(.title).monospacedDigit())
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(LocalizedStringKey(data.getStopTime(for: destination, on: entry).StationName.En)).foregroundColor(.secondary).font(Font.system(.caption))
                        Text("\(data.getStopTime(for: destination, on: entry).ArrivalTime)").font(Font.system(.title).monospacedDigit())
                    }
                }
                .padding(.horizontal, 5)
                

                
            }
            
            .padding(.vertical, 5)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            
        }
        .padding(.leading, 10)
        .background(Color.hsrColor)
        .cornerRadius(5)

        
    }
    
}


