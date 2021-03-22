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
    
    @Binding var isShow: Bool
    
    @Binding var selectedTimetable: RailDailyTimetable?
    
    var body: some View {
        
        VStack {
            
            ForEach(data.getDepartures(from: station.StationID).filter {
                (showArrivals ? true : !data.isEndingTerminus(for: $0, at: station)) &&
                    (showAvailable ? true : data.getTrainWillDepartAfterNow(for: $0, at: station))
            }) { departure in
                TrainEntryListRowView(train: departure, station: station)
                    .onTapGesture {
                        selectedTimetable = departure
                        isShow = true
                        
                    }
            }
        }
        
        .padding(.horizontal)
            
        
        

        
    }
    
    

    
}

