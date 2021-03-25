//
//  PlanTimetableView.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/6/21.
//

import SwiftUI

struct PlanTimetableView: View {
    @StateObject var data = HSRStore.shared
    @EnvironmentObject var network: NetworkStatus
    @AppStorage("showAvailable") var showAvailable = false
    var origin: Station?
    var destination: Station?
    @Binding var isShow: Bool
    @State var availableSeats: [AvailableSeat] = [] // goes in a vm i think

    @Binding var selectedTimetable: RailDailyTimetable?
    
    
    var body: some View {
        VStack {
            FareListingView(fareSchedule: data.fareSchedule[origin!.StationID]![destination!.StationID]!)
                .padding(.bottom, 10)
            ForEach(data.getDeparturesWith(from: origin!, to: destination!)
                        .filter {
                            (showAvailable ? true : data.getTrainWillDepartAfterNow(for: $0, at: origin!))
                        }) { entry in
                
                if let origin = origin, let destination = destination  {
                    TrainsRowView(
                        trainNo: entry.DailyTrainInfo.TrainNo,
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
        .padding(.horizontal)
        .onAppear {
            reload()
        }
        .onChange(of: network.connected) {status in
            if (status == true) {

                data.fetchAvailability(station: origin!, client: .init())
                availableSeats = []
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    reload()
                }
            }
            
        }
        .onChange(of: origin) {newOrigin in
            reload(origin: newOrigin!)
        }
        

        
    }
    
    func reload() {
        reload(origin: origin!)
    }
    
    private func reload(origin: Station) {
        
//            data.fetchAvailability(station: origin, client: .init())
            availableSeats = data.availableSeats[origin] ?? []
//                ?? []
        
        
        
    }
    
    
}

