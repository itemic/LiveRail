//
//  PlanTimetableView.swift
//  LiveRail
//
//  Created by Terran Kroft on 3/6/21.
//

import SwiftUI

struct PlanTimetableView: View {
    @StateObject var data = HSRStore.shared
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
                PlannerResultRowView(entry: entry, availability: availableSeats.first(where: {$0.TrainNo == entry.DailyTrainInfo.TrainNo}), origin: origin!, destination: destination!)
                    .onTapGesture {
                        selectedTimetable = entry
                        isShow = true
                    }
            }
            
        }
        .padding(.horizontal)
        .onAppear {
            reload()
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
            availableSeats = data.availableSeats[origin]!
//                ?? []
        
        
        
    }
    
    
}

