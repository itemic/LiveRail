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
    var origin: String
    var destination: String
    
    var fare: FareSchedule {
        data.fareSchedule[origin]![destination]!
    }
    
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
                    if (!entry.OriginStopTime.willDepartAfterNow) {
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
                .padding(.horizontal, 10)
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(entry.OriginStopTime.StationName.En)").foregroundColor(.secondary).font(Font.system(.caption))
                        Text("\(entry.OriginStopTime.DepartureTime)").font(Font.system(.title, design: .rounded).monospacedDigit().weight(.semibold))
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("").foregroundColor(.secondary).font(Font.system(.caption))
                        Text("→").font(Font.system(.title, design: .rounded).monospacedDigit())
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(entry.DestinationStopTime.StationName.En)").foregroundColor(.secondary).font(Font.system(.caption))
                        Text("\(entry.DestinationStopTime.ArrivalTime)").font(Font.system(.title, design: .rounded).monospacedDigit())
                    }
                }
                .padding(.horizontal, 10)
                
                if (extended) {
                    VStack {
                        FareListingView(fareSchedule: fare)
                    }
                    .padding([.top, .horizontal], 10)
                    
                    
                    
                }
                
            }
            //            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            
        }
        .padding(.leading, 10)
        .background(Color.orange)
        .cornerRadius(5)
        .onTapGesture {
            withAnimation {
                extended.toggle()
            }
        }
        
    }
    
}


