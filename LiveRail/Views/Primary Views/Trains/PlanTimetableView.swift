//
//  PlanTimetableView.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/6/21.
//

import SwiftUI

struct PlanTimetableView: View {
    @ObservedObject var data = HSRStore.shared
    @EnvironmentObject var network: NetworkStatus
    @AppStorage("showAvailable") var showAvailable = false
    var origin: Station?
    var destination: Station?
    @Binding var isShow: Bool
    //    @State var availableSeats: [AvailableSeat] = [] // goes in a vm i think
    var availableSeats: [AvailableSeat] {
        if let origin = origin {
            return data.availableSeats[origin] ?? []
        } else {return []}
    }
    
    
    @Binding var selectedTimetable: RailDailyTimetable?
    
    var filteredDepartures: [RailDailyTimetable] {
        data.getDeparturesWith(from: origin!, to: destination!)
            .filter {
                (showAvailable ? true : data.getTrainWillDepartAfterNow(for: $0, at: origin!))
            }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            FareListingView(fareSchedule: data.fareSchedule[origin!.StationID]![destination!.StationID]!)
            
            ForEach(filteredDepartures) { entry in
                
                if let origin = origin, let destination = destination  {
                    TrainsRowView(
                        trainNo: entry.DailyTrainInfo.TrainNo,
                        direction: entry.DailyTrainInfo.direction.abbreviated,
                        color: entry.DailyTrainInfo.direction.color,
                        origin: data.getStopTime(for: origin, on: entry).StationName.En,
                        originTime: data.getStopTime(for: origin, on: entry).DepartureTime,
                        destination: data.getStopTime(for: destination, on: entry).StationName.En,
                        destinationTime: data.getStopTime(for: destination, on: entry).ArrivalTime,
                        standardAvailability: availableSeats.first(where: {$0.TrainNo == entry.DailyTrainInfo.TrainNo})?.standardAvailability(to: entry.DailyTrainInfo.EndingStationID) ?? .unknown,
                        businessAvailability: availableSeats.first(where: {$0.TrainNo == entry.DailyTrainInfo.TrainNo})?.businessAvailability(to: entry.DailyTrainInfo.EndingStationID) ?? .unknown,
                        departed: !data.getTrainWillDepartAfterNow(for: entry, at: origin))
                        .onTapGesture {
                            selectedTimetable = entry
                            isShow = true
                        }
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
}

