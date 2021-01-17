//
//  TrainServiceView.swift
//  LiveRail
//
//  Created by Terran Kroft on 1/17/21.
//

import SwiftUI

struct TrainServiceView: View {
    var train: StationTimetable
    
    @ObservedObject var vm = HSRTrainViewModel()
    
 
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
            if (vm.train != nil) {
                ForEach(vm.train!.StopTimes, id: \.StopSequence) { stop in
                    
                    
                    
                    HStack(alignment: .center) {

                        VStack {
                            
                            if (stop.ArrivalTime != stop.DepartureTime) {
                                Text(stop.ArrivalTime).font(.system(.body, design: .monospaced))
                                    .foregroundColor(.gray)
                            }
                            Text(stop.DepartureTime).font(.system(.body, design: .monospaced))
                        }
                        VStack(spacing: 0) {
                            if (vm.train!.isStarting(stop: stop)) {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 10)
                            }
                        Rectangle()
                            .fill(Color.accentColor)
                            .frame(width: 10)
                        
                            if (vm.train!.isEnding(stop: stop)) {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 10)
                            }
                        }
                        .overlay(Circle()
                                    .strokeBorder(Color.primary, lineWidth: 2)
                                    .background(Circle().foregroundColor(Color(UIColor.systemBackground)))
//                                    .fill(Color(UIColor.systemBackground))
                                    .frame(width: (vm.train!.isEnding(stop: stop)) ? 18 : 12)
                                    
                        )
                        Text(stop.StationName.En)
                            
                        Spacer()
                        
                        if (vm.train!.isTrainAtStation(stop: stop)) {
                            Text("Train is here!")
                        }

//                        Text("A")
                    }
                    .frame(height: 100)

                    

                    
                    //MARK: End of FOREACH
                }
            }
            }
            .padding()
        }
        
        .onAppear {
            vm.fetchTrainDetails(for: train.TrainNo, client: .init())
        }
        .navigationTitle("Train Service")
        
    }
}


struct StoppingStationRowItemView: View {
    var stop: StopTime
//    var data: HSRDataStore
    
    var body: some View {
        Text("---")
    }
}
