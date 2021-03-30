//
//  StationView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/11/21.
//

import SwiftUI

struct StationTimetableView: View {
    
    
    var station: Station
    @StateObject var data = HSRStore.shared
//    @StateObject var vm = StationTimetableViewModel()
//    @State var currentDate = Date()
//    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()

    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("showArrivals") var showArrivals = false
    @AppStorage("showStopDots") var showStopDots = true
    
    
    @Binding var isShow: Bool
    
    @Binding var selectedTimetable: RailDailyTimetable?
    
    var filteredDepartures: [RailDailyTimetable] {
//        var _ = currentDate
//        var _ = print("AAA")r
        return data.getDepartures(from: station.StationID).filter {
            (showArrivals ? true : !data.isEndingTerminus(for: $0, at: station)) &&
//                (showAvailable ? true : data.getTrainWillDepartAfterNow(for: $0, at: station))
                (showAvailable ? true : Date.compare(now: Date(), to: data.getDepartureTime(for: $0, at: station)))
            
        }
        
    }
       

    var body: some View {
        
        VStack(spacing: 10) {
            
            ForEach(filteredDepartures) { departure in
                ZStack(alignment: .bottomTrailing) {
                    DeparturesRowView(trainNo: departure.DailyTrainInfo.TrainNo,
                                      destination: departure.DailyTrainInfo.EndingStationName.En,
                                      direction: departure.DailyTrainInfo.direction.abbreviated,
                                      departureTime: data.getDepartureTime(for: departure, at: station),
                                      color: departure.DailyTrainInfo.direction.color,
                                      departed: !data.getTrainWillDepartAfterNow(for: departure, at: station),
                                      departing: data.getTrainIsDepartingSoon(for: departure, at: station))
                    
                    if(showStopDots) {
                        StopPatternView(daily: departure)
                            .padding([.bottom, .trailing], 5)
                    }
                }
                .onTapGesture {
                    selectedTimetable = departure
                    isShow = true
                    
                }
            }
        }
        .padding(.horizontal, 10)
//        .onReceive(timer) {_ in
//
//            currentDate = Date()
//        }

        
//        .onAppear {
//            print("APPEAR \(station.StationCode)")
//            vm.station = station
//        }
//        .onChange(of: station) {newStation in
//            vm.station = newStation
//        }
    }
}

