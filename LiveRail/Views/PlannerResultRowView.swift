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
    var fare: FareSchedule {
        data.fareSchedule[entry.DailyTrainInfo.StartingStationID]![entry.DailyTrainInfo.EndingStationID]!
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
                        //                            .foregroundColor(entry.DailyTrainInfo.direction.color)
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
//                        Spacer().frame(height: 30)
//                        Text("Non-reserved \(fare.fare(for: .nonreserved)) TWD")
                        FareListingView(fareSchedule: fare)
                    }
                    .padding([.top, .horizontal], 10)
                    
                    
                    //                    ScrollView(.vertical, showsIndicators: false) {
                    
//                    VStack(alignment: .leading) {
//                        //                    Spacer()
//                        //                    FareListingView(fareSchedule: data.fareSchedule[entry.DailyTrainInfo.StartingStationID]![entry.DailyTrainInfo.EndingStationID]!)
//
//                    ZStack {
//                        HStack {
//                            Spacer().frame(width: 20)
//                            Rectangle()
//                                .foregroundColor(.red)
//                                .frame(width: 10)
//                            Spacer()
//
//                        }
//                        VStack {
//                        ForEach(stations) { station in
//
//                            HStack {
//                                Spacer().frame(width: 20)
//                                Circle()
//                                    .foregroundColor((timetable?.stopsAt(station) ?? false) ? .primary : .secondary)
//                                    .frame(width: 15)
//                                Text(station.StationName.En)
//                                    .foregroundColor((timetable?.stopsAt(station) ?? false) ? .primary : .secondary)
//                                Spacer()
//
//                            }
//                            //                        .background(Color.green)
//                        }
//                        }
//                    }
//                        //                    Spacer()
//                    }
//
//                    //                }
                    
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


