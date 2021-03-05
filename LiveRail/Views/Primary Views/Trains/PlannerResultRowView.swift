//
//  QueryResultsView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/12/21.
//

import SwiftUI

struct PlannerResultRowView: View {
    @StateObject var data = HSRDataStore.shared
    var entry: RailODDailyTimetable
    var availability: AvailableSeat?
    @State var extended: Bool = false
    var timetable: RailDailyTimetable?
    var origin: Station?
    var destination: Station?
    
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
                    Text("\(entry.DailyTrainInfo.TrainNo)").font(Font.system(.headline, design: .rounded).monospacedDigit().weight(.semibold))
                    Spacer()
                    if (!Date.compare(to: entry.OriginStopTime.DepartureTime)) {
                        Text("DEPARTED")
                            .font(Font.system(.subheadline, design: .rounded))
                            .foregroundColor(.red)
                            .padding(4)
                            .background(Color.red.opacity(0.2))
                            .cornerRadius(5)
                    } else {
                        AvailabilityIconView(text: "Standard", status: availability?.standardAvailability(to: entry.DailyTrainInfo.EndingStationID) ?? .unknown)
                        AvailabilityIconView(text: "Business", status: availability?.businessAvailability(to: entry.DailyTrainInfo.EndingStationID) ?? .unknown)
                    }
                    
                }
                .padding(.horizontal, 5)
                HStack {
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey(entry.OriginStopTime.StationName.En)).foregroundColor(.secondary).font(Font.system(.caption))
                        Text("\(entry.OriginStopTime.DepartureTime)").font(Font.system(.title, design: .rounded).monospacedDigit().weight(.semibold))
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("").foregroundColor(.secondary).font(Font.system(.caption))
                        Text("→").font(Font.system(.title, design: .rounded).monospacedDigit())
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(LocalizedStringKey(entry.DestinationStopTime.StationName.En)).foregroundColor(.secondary).font(Font.system(.caption))
                        Text("\(entry.DestinationStopTime.ArrivalTime)").font(Font.system(.title, design: .rounded).monospacedDigit())
                    }
                }
                .padding(.horizontal, 5)
                
                if (extended) {
//                    

                }
                
            }
            
            .padding(.vertical, 5)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            
        }
        .padding(.leading, 10)
        .background(Color.hsrColor)
        .cornerRadius(5)

        
    }
    
}


