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

    @AppStorage("showAvailable") var showAvailable = false
    @AppStorage("showArrivals") var showArrivals = false
    @AppStorage("showStopDots") var showStopDots = true

    
    @Binding var isShow: Bool
    
    @Binding var selectedTimetable: RailDailyTimetable?
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            ForEach(data.getDepartures(from: station.StationID).filter {
                (showArrivals ? true : !data.isEndingTerminus(for: $0, at: station)) &&
                    (showAvailable ? true : data.getTrainWillDepartAfterNow(for: $0, at: station))
            }) { departure in
                ZStack(alignment: .bottomTrailing) {
                    DeparturesRowView(trainNo: departure.DailyTrainInfo.TrainNo, destination: departure.DailyTrainInfo.EndingStationName.En, direction: departure.DailyTrainInfo.direction.abbreviated, departureTime: data.getDepartureTime(for: departure, at: station), color: departure.DailyTrainInfo.direction.color, departed: !data.getTrainWillDepartAfterNow(for: departure, at: station), departing: data.getTrainIsDepartingSoon(for: departure, at: station))
                    
                    if(showStopDots) {
                        StopPatternView(daily: departure)
                            .padding([.bottom, .trailing], 5)
                    }
                }

                    .onTapGesture {
                        selectedTimetable = departure
                        isShow = true
                        
                    }
                //                TrainEntryListRowView(train: departure, station: station)
            }
        }
        
        .padding(.horizontal, 10)
            
        
        

        
    }
    
    

    
}

